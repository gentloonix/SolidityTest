// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract Proxy {
    address public immutable admin;

    mapping(bytes32 => bytes32) public codeHashBySalt;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Proxy:: only admin");
        _;
    }

    // Receive ETH
    receive() external payable {
        _execute();
    }

    // Delegates the call based on selector and salt.
    fallback() external payable {
        // Get selector / contract salt.
        // Compute address of registered function.
        // See https://solidity.readthedocs.io/en/v0.7.4/control-structures.html#salted-contract-creations-create2
        // Execute call. Revert on failure or return on success.
        _execute();
    }

    // Retrieves the selector from calldata and the corresponding salt.
    function _getSaltAndSelector()
        internal
        pure
        returns (bytes32 salt, bytes4 selector)
    {
        selector = bytes4(msg.data);
        salt = keccak256(abi.encodePacked(selector));
        return (salt, selector);
    }

    function _computeAddress(bytes32 salt, bytes32 codeHash)
        internal
        view
        returns (address target)
    {
        bytes32 h = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, codeHash)
        );
        return address(uint160(uint256(h)));
    }

    function _execute() private {
        (bytes32 salt, ) = _getSaltAndSelector();
        bytes32 codeHash = codeHashBySalt[salt];

        require(codeHash != bytes32(0), "Proxy fallback():: not registered");

        address target = _computeAddress(salt, codeHash);

        // TODO use low level
        Address.functionDelegateCall(target, msg.data);
    }

    // Registers a new function selector and its corresponding code.
    function register(bytes4 selector, bytes memory code)
        public
        onlyAdmin
        returns (address addr, bytes32 salt)
    {
        salt = keccak256(abi.encodePacked(selector));

        require(
            codeHashBySalt[salt] == bytes32(0),
            "Proxy register():: already registered"
        );

        codeHashBySalt[salt] = keccak256(code);
        assembly {
            addr := create2(0, add(code, 32), mload(code), salt)
        }
        return (addr, salt);
    }
}
