//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    address[] public players;
    address[] public gameWinners;
    address public owner;

    constructor() {
        // The address that deploys the contract becomes the owner.
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // NOTE: The test suite seems to be looking for this error message specifically.
        require(msg.sender == owner, "ONLY_OWNER");
        _;

    }
    // This contract can receive (exactly) 0.1 ETH payments.
    receive() external payable {
        require(msg.value == 0.1 ether, "Only payments of 0.1 ether accepted!");
        players.push(msg.sender);
    }

    // Make balance viewable (only by contract owner).
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // Determine the winner.
    function pickWinner() public onlyOwner {
        // Require 3+ players to play.
        // NOTE: The test suite seems to be looking for this error message specifically.
        require(players.length >= 3, "NOT_ENOUGH_PLAYERS");

        uint256 r = random();
        address winner;

        winner = players[r % players.length];
        (bool isSuccessful,) = winner.call{value: getBalance()}("");
        require(isSuccessful, "Failed to pay out winner!");

        gameWinners.push(winner);
        delete players;
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
