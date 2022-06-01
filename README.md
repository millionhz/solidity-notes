# Smart Contract

Digital Contracts stored on a blockchain that are executed when predetermined conditions are met. 

# Solidity

- [Solidity Cheatsheet](https://docs.soliditylang.org/en/v0.8.11/cheatsheet.html)

- [Solidity Tutorial](https://www.tutorialspoint.com/solidity/)

# `pragma` directive

`pragma` is used to specify the version of solidity being used in the contract.

```typescript
pragma solidity 0.8.0
```

# Common Data Types

| Type                | Keyword               | Values                                                                                                                                                                                                                          |
| ------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Boolean             | `bool`                | true/false                                                                                                                                                                                                                      |
| Integer             | `int`/`uint`          | Signed and unsigned integers of varying sizes.                                                                                                                                                                                  |
| Integer             | `int8` to `int256`    | Signed int from 8 bits to 256 bits. (`int256` is the same as `int`)                                                                                                                                                             |
| Integer             | `uint8` to `uint256`  | Unsigned int from 8 bits to 256 bits. (`uint256` is the same as `uint`)                                                                                                                                                         |
| Fixed Point Numbers | `fixed`/`unfixed`     | Signed and unsigned fixed point numbers of varying sizes.                                                                                                                                                                       |
| Fixed Point Numbers | fixedMxN              | Signed fixed point number where M represents number of bits taken by type and N represents the decimal points. M should be divisible by 8 and goes from 8 to 256. N can be from 0 to 80. (`fixed` is same as `fixed128x18`)     |
| Fixed Point Numbers | ufixedMxN             | Unsigned fixed point number where M represents number of bits taken by type and N represents the decimal points. M should be divisible by 8 and goes from 8 to 256. N can be from 0 to 80. (`ufixed` is same as `ufixed128x18`) |
| Address             | `address`             | Holds a 20 byte value (plain address can not send ether)                                                                                                                                                                        |
| Payable Address     | `address payable`     | Same as address, but with the additional members transfer and send.                                                                                                                                                             |
| Bytes               | `bytes1` to `bytes32` | Bytes for storage, going from 1 to 32 bytes with increments of 1.                                                                                                                                                               |

# Bytes

[Solidity Bytes](https://jeancvllr.medium.com/solidity-tutorial-all-about-bytes-9d88fdb22676)

# Strings in Solidity

[Solidity - Strings](https://www.tutorialspoint.com/solidity/solidity_strings.htm)

Strings in solidity behave like `const char*` in C.

## Passing and returning strings (`memory` keyword)

If we want to pass or return a string, we need to a place for the string to be saved in. For that we use the `memory` keyword. 

`memory` keyword provides a temporary storage space for the user to store data in.

There is also a `storage` keyword that provides a persistent storage space for users.

## Example

```ts
// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract StringExercise{
    string private favoriteColor = "blue";

    constructor() {}

    function getColor() public view returns(string memory){
        return favoriteColor;
    }

    function changeColor(string memory newColor) public {
        favoriteColor = newColor;
    }

    function getColorSize() public view returns(uint){
        return bytes(favoriteColor).length;
    }
}
```

# Built-in Globals & Important Functions

[Built-in Globals](https://docs.soliditylang.org/en/v0.8.10/cheatsheet.html?highlight=msg.sender#global-variables)

[Units and Globally Available Variables](https://docs.soliditylang.org/en/v0.8.9/units-and-global-variables.html)


# Operators and Precedence

[Operators and Precedence](https://docs.soliditylang.org/en/v0.8.10/cheatsheet.html#order-of-precedence-of-operators)

# Functions

```typescript
/*
function function-name(parameters) access scope returns)() {
    body
}
*/

function setNumber(uint val) public {
    number = val;
} 
```

## Modifiers

- `pure` for functions: Disallows modification or access of state.

- `view` for functions: Disallows modification of state.

- `payable` for functions: Allows them to receive Ether together with a call.

- `constant` for state variables: Disallows assignment (except initialisation), does not occupy storage slot.

- `immutable` for state variables: Allows exactly one assignment at construction time and is constant afterwards. Is stored in code.

- `anonymous` for events: Does not store event signature as topic.

- `indexed` for event parameters: Stores the parameter as topic.

- `virtual` for functions and modifiers: Allows the function’s or modifier’s behaviour to be changed in derived contracts.

- `override`: States that this function, modifier or public state variable changes the behaviour of a function or modifier in a base contract.

## Writing Function Modifiers

```typescript
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.1 <0.9.0;

contract owned {
    constructor() { owner = payable(msg.sender); }
    address payable owner;

    // This contract only defines a modifier but does not use
    // it: it will be used in derived contracts.
    // The function body is inserted where the special symbol
    // `_;` in the definition of a modifier appears.
    // This means that if the owner calls this function, the
    // function is executed and otherwise, an exception is
    // thrown.
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _; 
        // the '_' is important. It is the the place where the
        // function body will get copied to.
    }
}

contract destructible is owned {
    // This contract inherits the `onlyOwner` modifier from
    // `owned` and applies it to the `destroy` function, which
    // causes that calls to `destroy` only have an effect if
    // they are made by the stored owner.
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

contract priced {
    // Modifiers can receive arguments:
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}

contract Register is priced, destructible {
    mapping (address => bool) registeredAddresses;
    uint price;

    constructor(uint initialPrice) { price = initialPrice; }

    // It is important to also provide the
    // `payable` keyword here, otherwise the function will
    // automatically reject all Ether sent to it.
    function register() public payable costs(price) {
        registeredAddresses[msg.sender] = true;
    }

    function changePrice(uint _price) public onlyOwner {
        price = _price;
    }
}

contract Mutex {
    bool locked;
    modifier noReentrancy() {
        require(
            !locked,
            "Reentrant call."
        );
        locked = true;
        _;
        locked = false;
    }

    /// This function is protected by a mutex, which means that
    /// reentrant calls from within `msg.sender.call` cannot call `f` again.
    /// The `return 7` statement assigns 7 to the return value but still
    /// executes the statement `locked = false` in the modifier.
    function f() public noReentrancy returns (uint) {
        (bool success,) = msg.sender.call("");
        require(success);
        return 7;
    }
}
```

[Function Modifiers](https://docs.soliditylang.org/en/v0.8.11/contracts.html?#function-modifiers)

## Visibility Specifiers

- `public`: visible externally and internally (creates a [getter function](https://docs.soliditylang.org/en/v0.8.10/contracts.html#getter-functions) for storage/state variables)

- `private`: only visible in the current contract

- `external`: only visible externally (only for functions) - i.e. can only be message-called (via `this.func`)

- `internal`: only visible internally (inheritance)

# Control Flow

Solidity currently only supports if statements.

```typescript
function getResult() public view returns(uint memory) {
    uint a = 1; 
    uint b = 2;
    uint c = 3;
    uint result;

    if( a > b && a > c) {   // if else statement
        result = a;
    } else if( b > a && b > c ){
        result = b;
    } else {
        result = c;
    }       
    return result; 
}
```

Solidity also supports `<conditional> ? <if-true> : <if-false>`.

# Error Handling

| Function                                              | Description                                                                                                                                                                        |
|:-----------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| `assert(bool condition)`                              | In case the `condition` is not met, the methods causes and invalid opcode and any changes done to the state get reverted. This method is to be used for internal errors.           |
| `require(bool condition, string memory message = "")` | In case the `condition` is not met, the method call reverts to its original state. The method is to be used for inputs or external components. Returns the `message` if specified. |
| `revert(string memory message = "")`                  | Method aborts the contract execution and reverts any changes done to the state. Returns the `message` if specified.                                                                |


# Loops

Solidity supports C-style:

- `for` loops

- `while` loops

- `do while` loops

- `break` statement

- `continue` statement

```typescript
for (j = _i; j != 0; j /= 10) {
    len++;         
}
```

# Arrays

## Statically Sized

```typescript
uint my_array[3] = [1, 2, 3];
// OR
uint balance[] = [1, 2, 3];
```

## Dynamically Sized

```typescript
uint[] arrayName;
```

## [Array Members](https://docs.soliditylang.org/en/v0.8.10/types.html?highlight=array%20method#array-members)

- `push()`

- `pop()`

- `length`

- `delete` *(length does not change after delete)*

# Enums

```typescript
enum drinkSize {LARGE, MEDIUM, SMALL};
```

# Map

```typescript
mapping(address => uint) public my_map;
// here address is the key and uint is the value
```

## Using maps

```typescript
contract Mapping {

    mapping(address => uint) public my_map;

    function setAddress(address _address, uint index) public {
        my_map[_address] = index;
    }

    function getIndex(address _address) public view returns(uint) {
        return my_map[_address];
    }

    function removeAddress(address _address) public {
        delete my_map[_address];
    }
}
```

# Structs

```typescript
struct Movie {
    string title;
    string director;
    uint id;
}

contract Structs {

    Movie movie;

    function makeMovie() public {
        movie = Movie("Spiderman", "Someone", 23);
    }

    function getMovieName() public view returns(string memory) {
        return movie.title; 
    }

}
```


# Events

Contracts need to ping the ethereum virtual machine (blockchain) after certain events. For that functionality we use Solidity events. 

Solidity events are declared with the `event` keyword and are emitted using the `emit` keyword.

```typescript
event Transfer(address indexed from, address indexed to, uint256 value);


function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");

    _beforeTokenTransfer(address(0), account, amount);

    _totalSupply += amount;
    _balances[account] += amount;

    emit Transfer(address(0), account, amount);

    _afterTokenTransfer(address(0), account, amount);
}
```

# `fallback` and `recieve` functions

[fallback and receive split - soliditylang](https://blog.soliditylang.org/2020/03/26/fallback-receive-split/)

# Constructor

- A contract can have only one constructor.

- A constructor code is executed once when a contract is created and it is used to initialize contract state.

- Constructor code or any internal method used only by constructor are not included in final code.

- A constructor can be either public or internal.

- A internal constructor marks the contract as abstract.

- In case, no constructor is defined, a default constructor is present in the contract.

- Solidity **does not** support `this` keyword.

# Inheritance

- `is` keyword

- Calling base constructor from derived contract

```typescript
// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;


contract Base{
    uint public data;

    constructor(uint _data) {
        data = _data;
    }
}

contract Derived is Base{
    constructor(uint _data) Base(_data) {}
}
```

# Interfaces

**Interfaces are the blueprints for a contract are also used to interact with other contracts that are already deployed onto the blockchain.**

## Example

```typescript
// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

interface UniSwapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
} 

interface UniSwapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract MyContract {
    address private v2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address pair;

    function getPair() public {
        pair = UniSwapV2Factory(v2Factory).getPair(dai, weth);
    }

    function getReserves() public view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) {
        return UniSwapV2Pair(pair).getReserves();
    }
}
```

# `selfdestruct`

`selfdestruct(address payable recipient)` destroys the current contract, sending its funds to the given address.


# Library

Libraries can be declared using the `library` keyword.

- A library function can be called directly.

- A library can not be destroyed as it is stateless.

- A library cannot have state variables.

- A library can not inherit any elements.

- A library can not be inherited.

```typescript
library Search {
    function getIndex(uint[] memory arr, uint data) public pure returns (uint) {
        for(uint i = 0; i < arr.length; i++)
        {
            if(data == arr[i])
            {
                return i;
            }
        }
        return 0;
    }
}

contract Test {

    uint[] arr = [1, 2, 3, 4, 5];

    function getIndex(uint data) public view returns (uint) {
        return Search.getIndex(arr, data);
    }
}
```

## `using` keyword

```typescript
// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

library Search {
    function getIndex(uint[] memory arr, uint data) public pure returns (uint) {
        for(uint i = 0; i < arr.length; i++)
        {
            if(data == arr[i])
            {
                return i;
            }
        }
        return 0;
    }
}

contract Test {

    using Search for uint[]; // use methods in Search for all uint[]

    uint[] arr = [1, 2, 3, 4, 5];

    function getIndex(uint data) public view returns (uint) {
        return arr.getIndex(data);
    }
}
```

# Other Solidity Concepts

- [ ] Abstract contracts

- [ ] `new` keyword (deploy new contracts)

- [ ] `super` keyword

- [ ] `selector` keyword

- [ ] [Ethereum Inline Assembly](https://www.ethervm.io/)