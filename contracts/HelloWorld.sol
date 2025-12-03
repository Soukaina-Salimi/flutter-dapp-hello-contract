// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract HelloWorld {
    string private yourName;

    constructor() {
        yourName = "Unknown";
    }

    function getName() public view returns (string memory) {
        return yourName;
    }

    function setName(string memory nm) public {
        yourName = nm;
    }
}
