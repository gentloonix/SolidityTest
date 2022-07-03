// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

contract Multicall {
    // NOTE exploitable multiple payable, use address(this).balance not msg.value
    function multicall(bytes[] calldata data)
        public
        payable
        returns (bytes[] memory results)
    {
        uint256 dataLength = data.length;
        results = new bytes[](dataLength);
        for (uint256 i = 0; i < dataLength; ++i) {
            (bool success, bytes memory result) = address(this).delegatecall(
                data[i]
            );

            if (!success) {
                // section based on https://ethereum.stackexchange.com/a/83577
                // If the _res length is less than 68, then the transaction failed silently (without a revert message)
                if (result.length < 68)
                    revert("Multicall:: low-level delegatecall");

                assembly {
                    // Slice the sighash.
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string))); // All that remains is the revert string
            }

            results[i] = result;
        }
        return results;
    }
}
