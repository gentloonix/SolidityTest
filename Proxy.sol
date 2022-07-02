pragma solidity ^0.8.0;

contract Proxy {
    address public immutable admin;

    mapping(bytes32 => bytes32) public codeHashBySalt;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // Receive ETH
    receive() external payable {}

    // Delegates the call based on selector and salt.
    fallback() external payable {
        // Get selector / contract salt.
        // Compute address of registered function.
        // See https://solidity.readthedocs.io/en/v0.7.4/control-structures.html#salted-contract-creations-create2
        // Execute call. Revert on failure or return on success.
    }

    // Registers a new function selector and its corresponding code.
    function register(bytes4 selector, bytes memory code)
        public
        onlyAdmin
        returns (address addr, bytes32 salt)
    {}

    // Retrieves the selector from calldata and the corresponding salt.
    function _getSaltAndSelector()
        internal
        pure
        returns (bytes32 salt, bytes4 selector)
    {}
}
