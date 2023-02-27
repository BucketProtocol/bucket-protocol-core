// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IBucketProtocolV1 {
    function deposit(uint256 amount) external returns (string memory, uint256);

    function deposit(string memory withdrawCode, uint256 amount)
        external
        returns (string memory, uint256);

    function deposit(address tokenAddr, uint256 amount)
        external
        returns (string memory, uint256);

    function deposit(
        string memory withdrawCode,
        address tokenAddr,
        uint256 amount
    ) external returns (string memory, uint256);

    function withdraw(string memory withdrawCode, uint256 amount) external returns (uint256);

    function withdraw(address tokenAddr, string memory withdrawCode, uint256 amount)
        external
        returns (uint256);

    function balance(string memory withdrawCode)
        external
        view
        returns (uint256);

    function balance(address tokenAddr, string memory withdrawCode)
        external
        view
        returns (uint256);

    function getWithdrawCodeList(address msgSender)
        external
        view
        returns (string[] memory);

    event Deposit(address indexed from, uint256 indexed amount);
    event Withdraw(address indexed from, uint256 indexed amount);
}
