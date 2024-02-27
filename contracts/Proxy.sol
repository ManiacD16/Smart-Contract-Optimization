// Proxy.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Registry.sol";

contract Proxy {
    // Admin address that has permission to update the registry
    address public admin;

    // Instance of the Registry contract that stores function IDs and implementation addresses
    Registry public registry;

    // Current implementation contract address
    address public implementation;

    // Modifier to restrict functions to only be callable by the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Constructor to set the initial values of admin, registry, and implementation
    constructor(address _registry, address initialImplementation) {
        admin = msg.sender;
        registry = Registry(_registry);
        implementation = initialImplementation;
    }

    // Function to update the address of the registry contract
    function updateRegistry(address _registry) external onlyAdmin {
        require(_registry != address(0), "Invalid registry address");
        registry = Registry(_registry);
    }

    // Fallback function to delegate function calls to the appropriate implementation contract
    fallback() external payable {
        // Get the implementation contract address based on the function ID
        address _impl = registry.getImplementation(msg.sig);
        require(_impl != address(0), "Implementation not found");

        // Delegate the function call to the implementation contract
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    // Receive function to allow the contract to receive Ether
    receive() external payable {}
}

