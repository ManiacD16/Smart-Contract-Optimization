// Admin.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Proxy.sol";

contract Admin {
    // Address of the admin who can upgrade implementations and create proxies
    address public admin;

    // Mapping of function IDs to their corresponding implementation contract addresses
    mapping(bytes4 => address) public implementations;

    // Constructor to set the initial admin address
    constructor() {
        admin = msg.sender;
    }

    // Function to upgrade the implementation for a specific function ID
    function upgradeImplementation(bytes4 funcId, address newImplementation) external {
        require(msg.sender == admin, "Only admin can upgrade implementation");
        implementations[funcId] = newImplementation;
    }

    // Function to create a new Proxy contract with the specified initial implementation
    function createProxy(address initialImplementation) external returns (address) {
        // Deploy a new Proxy contract, passing the address of this Admin contract and initial implementation
        Proxy proxy = new Proxy(address(this), initialImplementation);
        return address(proxy);
    }
}
