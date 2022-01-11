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