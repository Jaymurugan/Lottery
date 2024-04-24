// Just an example to make sure that we are pushing to github properly.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract GitPush {
    string name = "Jay";

    function assign() public view returns (string memory) {
        return name;
    }
}
