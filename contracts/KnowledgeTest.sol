//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;
    address public owner;

    constructor() {
      owner = msg.sender;
    }

    function changeTokens() public {
      tokens[0] = "VET";
    }

    function getBalance() public view returns (uint) {
      return address(this).balance;
    }

    function transferAll(address _addr) external {
      require(msg.sender == owner, "ONLY_OWNER");
      (bool isSuccess,) = _addr.call{value: address(this).balance}("");
      require (isSuccess, "Transaction not successful!");
    }

    function start() external {
      players.push(msg.sender);
    }

    function concatenate(string memory str1, string memory str2)
    external
    pure
    returns (string memory) {
      return string(abi.encodePacked(str1, str2));
    }

    receive() external payable {}
}
