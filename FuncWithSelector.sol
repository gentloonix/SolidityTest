// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuncWithSelector {
    // When written in solidity, this will have the desired effect.
    function testProxy()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0xb4e81320;
        selectorWord = keccak256(abi.encodePacked("testProxy()"));
    }

    function testMulticall()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0xbe13bddb;
        selectorWord = keccak256(abi.encodePacked("testMulticall()"));
    }

    function testMulticall1()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0xe4382903;
        selectorWord = keccak256(abi.encodePacked("testMulticall1()"));
    }
}
