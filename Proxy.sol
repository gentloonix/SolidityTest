// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    // EIP1967
    bytes32 public constant ADMIN_SLOT =
        0x77ea5b78a94496fa612fecea03b8ff8bc74d0e5c95428dc952709b4acb9365e5;

    mapping(bytes32 => bytes32) public codeHashBySalt;

    constructor() {
        assert(ADMIN_SLOT == keccak256("ebs369.proxy.admin"));
        bytes32 adminSlot = ADMIN_SLOT;
        address adminAddr = msg.sender;
        assembly {
            sstore(adminSlot, adminAddr)
        }
    }

    modifier onlyAdmin() {
        bytes32 adminSlot = ADMIN_SLOT;
        address adminAddr;
        assembly {
            adminAddr := sload(adminSlot)
        }
        require(msg.sender == adminAddr, "Proxy:: only admin");
        _;
    }

    // Receive ETH
    receive() external payable {
        _execute();
    }

    // Delegates the call based on selector and salt.
    fallback() external payable {
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

    // Compute address (create2) from salt and code hash
    function _computeAddress(bytes32 salt, bytes32 codeHash)
        internal
        view
        returns (address target)
    {
        bytes32 addr = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, codeHash)
        );
        return address(uint160(uint256(addr)));
    }

    // Execute
    function _execute() private {
        // Get selector / contract salt.
        (bytes32 salt, ) = _getSaltAndSelector();
        bytes32 codeHash = codeHashBySalt[salt];

        require(codeHash != bytes32(0), "Proxy fallback():: not registered");

        // Compute address of registered function.
        address target = _computeAddress(salt, codeHash);

        // Execute call. Revert on failure or return on success.
        assembly {
            calldatacopy(0, 0, calldatasize())
            let ok := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            if eq(ok, 0) {
                revert(0, returndatasize())
            }
            return(0, returndatasize())
        }
    }

    // Registers a new function selector and its corresponding code.
    function register(bytes4 selector, bytes memory code)
        public
        payable
        onlyAdmin
        returns (address addr, bytes32 salt)
    {
        salt = keccak256(abi.encodePacked(selector));

        require(
            codeHashBySalt[salt] == bytes32(0),
            "Proxy register():: already registered"
        );

        codeHashBySalt[salt] = keccak256(code);

        uint256 value = msg.value;
        assembly {
            addr := create2(value, add(code, 0x20), mload(code), salt)
        }

        require(addr != address(0), "Proxy register():: create2");

        return (addr, salt);
    }
}
