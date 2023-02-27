// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BucketToken is ERC20 {
    constructor() ERC20("Bucket Protocol Token", "Bucket Token") {
        _mint(msg.sender, 1 * 10**8 * 10**18);
    }
}
