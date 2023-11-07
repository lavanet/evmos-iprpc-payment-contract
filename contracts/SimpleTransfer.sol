// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SimpleTransfer {
    address public owner;
    address public backupOwner;

    constructor() {
        owner = msg.sender;
        backupOwner = address(0);
    }

    function payProviders(Provider[] memory providers) public {
        require(msg.sender == owner || msg.sender == backupOwner, "Only the owner / backup can call this function");
        uint256 totalAmount = 0;
        uint256 balanceAtStart = address(this).balance;
        for (uint256 i = 0; i < providers.length; i++) {
            address payable providerAddress = payable(providers[i].name);
            uint256 amount = providers[i].value;
            totalAmount += amount;
            providerAddress.transfer(amount);
        }
        require(balanceAtStart >= totalAmount, "Insufficient balance in the contract");
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner || msg.sender == backupOwner, "Only the owner / backup can call this function");
        owner = newOwner;
    }

    function setBackUpOwner(address newBackupOwner) public {
        require(msg.sender == owner || msg.sender == backupOwner, "Only the owner / backup can call this function");
        backupOwner = newBackupOwner;
    }

    receive() external payable {
        // Allow anyone to add funds to the contract
        require(msg.value > 0, "Value must be greater than 0");
    }

    struct Provider {
        address name;
        uint256 value;
    }
}
