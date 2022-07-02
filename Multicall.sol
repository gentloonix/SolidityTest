// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

contract Multicall {
    function multicall(bytes[] calldata data)
        public
        payable
        returns (bytes[] memory results)
    {}
}
