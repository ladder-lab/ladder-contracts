// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;


import '../../../../openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol';
import '../../../../openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol';
import './interfaces/ILadderV1Factory.sol';
import './LadderV1Pair721.sol';
import './libraries/ERC165Checker.sol';

contract LadderV1Factory721 is Initializable,ILadderV1Factory {
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;
    //if erc721    zero if not nft,one is nft
    mapping(address => uint) public isNFT;
    
    // Beacon address of UniswapV2Pair
    address public pairBeacon;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function initialize(address _feeToSetter, address _pairBeacon) public initializer {
        feeToSetter = _feeToSetter;
        pairBeacon = _pairBeacon;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }
    
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'LadderV1: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'LadderV1: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'LadderV1: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = abi.encodePacked(type(BeaconProxy).creationCode, abi.encode(pairBeacon, new bytes(0)));
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ILadderV1Pair721(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        if(ERC165Checker.supportsInterface(token0,_INTERFACE_ID_ERC721)){
            isNFT[token0] = 1;
        }
        if(ERC165Checker.supportsInterface(token1,_INTERFACE_ID_ERC721)){
            isNFT[token1] = 1;
        }
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'LadderV1: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'LadderV1: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function register(address token1155, uint256 token1155Id) external returns (address hashAddress){}
    function isOriginERC1155(address hashAddress) external view returns (bool){}
    function getOriginInfo(address hashAddress) external view returns (address, uint256){}

    function isERC721(address token) public view returns (bool) {
        return isNFT[token] == 1;
    }
}
