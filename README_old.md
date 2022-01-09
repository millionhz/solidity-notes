# BlockChain Basics

## Transaction Object/Contract

A Transaction Object is used to send transactions for one account to another.

| Data Member       | Description                                                                                                                                  |
|:-----------------:|:--------------------------------------------------------------------------------------------------------------------------------------------:|
| none              | Total number of transactions sent by the sender                                                                                              |
| to                | Address of the destination account                                                                                                           |
| value             | Amount of the transaction                                                                                                                    |
| gasPrice          | Amount of ether the sender is willing to pay per unit gas for the transaction                                                                |
| gasLimit/startGas | Units of gas that the transaction will use                                                                                                   |
| v \| r \| s       | Cryptographic pieces of data that can be used to generate the senders account address. (These values are generated from senders private key) |

## Block Time

Time required to mine a specific block of specific difficulty.

The difficulty is always fluctuating on an active blockchain and so is the block time. 

## Smart Contract (Contract Account)

An account controlled by code.  

| Field   | Description                         |
|:-------:|:-----------------------------------:|
| balance | Amount of balance in the account    |
| storage | Data storage space fot the contract |
| code    | Raw machine code for the contract   |

Smart Contracts are network specific, i.e. a contract on the Rinkeby Network is completely isolated from the same contract on the Main Network

The smart contract source code serves as a class and the deployment of that code serves as an instance of that said contract.

### ABI

Solidity code gets compiled into Application Binary Interface (ABI), which enables external applications (written in javascript etc) to use the smart contract.

## Deployment of Contracts

Solidity compiler compiles the contract source code into an ABI and bytecode. The bytecode is what is deployed onto the actual network of choice. The deployment of bytecode is done by a tool called **Truffle**.

# Smart Contracts in Solidity

Smart Contracts in solidity behave like classes. We define a contract (like we define a class). The contract is then compiled into an Application Binary Interface. The contract cant then be deployed onto the blockchain and can be interacted with the functions we declared while writing the contract.

## Sample Smart Contract

```typescript
pragma solidity ^0.4.17;

contract Inbox {
    string public message;

    constructor (string initialMessage) public {
        message = initialMessage;
    }

    function setMessage(string newMessage) public {
        message = newMessage;
    }

    function getMessage() public view returns (string) {
        return message;
    }
}
```

Note: When we declare a data member as public, a getter function is created automatically with the same name as the data member. This makes our `getMessage()` function redundant.

## Solidity Functions

```typescript
function getMessage() public view returns (string) {
    return message;
}
```

- `getMessage` - function name

- `public view` - function type

- `returns (string)` - return type

## Function Types

| Type            | Description                                                                               |
|:---------------:|:-----------------------------------------------------------------------------------------:|
| public          | Function is accessible publicly                                                           |
| private         | Function is accessible only privately                                                     |
| view / constant | Function **returns** data and does **not modify** contract's data members (like a getter) |
| pure            | Function will not **modify** or **read** contract's data members                          |
| payable         | Function call might result in transfer of assets                                          |

Whenever the data of a contract is modified, the change needs to be validated, thus causing a delay (block time).

## Executing a Functions on the the BlockChain

### Call

Function calls do not modify a contract's data and may or may not return a value. Functions can be called instantly and for free.

### Transaction

Transactions may or may not modify a contract's data and return a transaction hash. Transactions take time to execute and cost money. 
