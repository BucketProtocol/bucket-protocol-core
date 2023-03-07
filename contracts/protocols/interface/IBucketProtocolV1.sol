// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IBucketProtocolV1 {
    function deposit() external payable;
    function depositByWithdrawCode(bytes32 withdrawCode) external payable;
    function depositToken(address tokenAddr, uint256 amount) external;
    function depositTokenByWithdrawCode(bytes32 withdrawCode,address tokenAddr,uint256 amount) external;

    function withdrawByWithdrawCode(bytes32 withdrawCode, uint256 amount) external;
    function withdrawTokenByWithdrawCode(address tokenAddr, bytes32 withdrawCode, uint256 amount) external;

    function balanceByWithdrawCode(bytes32 withdrawCode) external view returns (uint256);
    function balanceTokenByWithdrawCode(address tokenAddr, bytes32 withdrawCode) external view returns (uint256);

    function getWithdrawCodeList() external view returns (bytes32[] memory);

    event Deposit(address indexed from, uint256 indexed amount);
    event Withdraw(address indexed from, uint256 indexed amount);
}
