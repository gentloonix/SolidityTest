// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuncWithSelector {
    // When written in solidity, this will have the desired effect.
    function testProxy()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory bSelectorWord = "testProxy()"; // use bytes over bytes32 to avoid accidential trimming
        selector = bytes4(keccak256(bSelectorWord));
        assembly {
            selectorWord := mload(add(bSelectorWord, 32))
        }
        return (selector, selectorWord);
    }

    function testMulticall()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory bSelectorWord = "testMulticall()";
        selector = bytes4(keccak256(bSelectorWord));
        assembly {
            selectorWord := mload(add(bSelectorWord, 32))
        }
        return (selector, selectorWord);
    }

    function testMulticall1()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        bytes memory bSelectorWord = "testMulticall1()";
        selector = bytes4(keccak256(bSelectorWord));
        assembly {
            selectorWord := mload(add(bSelectorWord, 32))
        }
        return (selector, selectorWord);
    }
}
