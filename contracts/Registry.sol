// Registry.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Registry {
    // Address of the admin who can update the registry
    address public admin;

    // Mapping of function IDs to their corresponding implementation contract addresses
    mapping(bytes4 => address) public implementations;

    // Event emitted when an implementation is updated
    event ImplementationUpdated(bytes4 indexed funcId, address indexed implementation);

    // Event emitted when a new implementation is added
    event ImplementationAdded(bytes4 indexed funcId, address indexed implementation);

    // Event emitted when an implementation is removed
    event ImplementationRemoved(bytes4 indexed funcId);

    // Modifier to restrict functions to only be callable by the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Constructor to set the initial value of admin to the address deploying the contract
    constructor() {
        admin = msg.sender;
    }

    // Function to update the implementation for a specific function ID
    function updateImplementation(bytes4 funcId, address newImplementation) external onlyAdmin {
        require(newImplementation != address(0), "Invalid implementation address");
        implementations[funcId] = newImplementation;
        emit ImplementationUpdated(funcId, newImplementation);
    }

    // Function to add a new implementation for a specific function ID
    function addImplementation(bytes4 funcId, address implementation) external onlyAdmin {
        require(implementation != address(0), "Invalid implementation address");
        require(implementations[funcId] == address(0), "Function ID already exists");
        implementations[funcId] = implementation;
        emit ImplementationAdded(funcId, implementation);
    }

    // Function to remove the implementation for a specific function ID
    function removeImplementation(bytes4 funcId) external onlyAdmin {
        require(implementations[funcId] != address(0), "Function ID does not exist");
        delete implementations[funcId];
        emit ImplementationRemoved(funcId);
    }

    // Function to get the implementation address for a specific function ID
    function getImplementation(bytes4 funcId) external view returns (address) {
        return implementations[funcId];
    }
}

