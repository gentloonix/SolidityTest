// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuncWithSelector {
    // When written in solidity, this will have the desired effect.
    function testProxy()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0x12345678;
        selectorWord = selector;
    }

    function testMulticall()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0x12345679;
        selectorWord = selector;
    }

    function testMulticall1()
        public
        pure
        returns (bytes4 selector, bytes32 selectorWord)
    {
        selector = 0x12345680;
        selectorWord = selector;
    }
}
