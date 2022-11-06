// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ILadderV1Factory {
   

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function register(address token1155, uint256 token1155Id) external returns (address hashAddress);
    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function isOriginERC1155(address hashAddress) external view returns (bool);
    function getOriginInfo(address hashAddress) external view returns (address, uint256);
    
    function isERC721(address token) external view returns (bool);
}
