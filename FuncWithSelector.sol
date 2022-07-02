// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuncWithSelector {
    // When written in solidity, this will have the desired effect.
    function testProxy()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory fn = "testProxy()";
        selector = bytes4(keccak256(abi.encodePacked(fn)));
        assembly {
            selectorWord := mload(add(fn, 32))
        }
        return (selector, selectorWord);
    }

    function testMulticall()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory fn = "testMulticall()";
        selector = bytes4(keccak256(abi.encodePacked(fn)));
        assembly {
            selectorWord := mload(add(fn, 32))
        }
        return (selector, selectorWord);
    }

    function testMulticall1()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory fn = "testMulticall1()";
        selector = bytes4(keccak256(abi.encodePacked(fn)));
        assembly {
            selectorWord := mload(add(fn, 32))
        }
        return (selector, selectorWord);
    }
}
