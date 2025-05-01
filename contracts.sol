// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTrading {
    struct Household {
        uint energyBalance; // in kWh
        uint etherBalance;  // in wei
    }

    mapping(address => Household) public households;

    event EnergyTransferred(address indexed from, address indexed to, uint energyAmount, uint price);

    // Allow households to add energy and Ether to their account
    function deposit(uint energyAmount) external payable {
        households[msg.sender].energyBalance += energyAmount;
        households[msg.sender].etherBalance += msg.value;
    }

    // Trade energy between households
    function tradeEnergy(address to, uint energyAmount, uint price) external {
        require(households[msg.sender].energyBalance >= energyAmount, "Insufficient energy");
        require(households[to].etherBalance >= price, "Buyer has insufficient funds");

        // Transfer energy
        households[msg.sender].energyBalance -= energyAmount;
        households[to].energyBalance += energyAmount;

        // Transfer Ether
        households[to].etherBalance -= price;
        households[msg.sender].etherBalance += price;

        emit EnergyTransferred(msg.sender, to, energyAmount, price);
    }

    // Check balances
    function getBalances(address user) external view returns (uint energy, uint etherBal) {
        energy = households[user].energyBalance;
        etherBal = households[user].etherBalance;
    }
}
