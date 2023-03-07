// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interface/IBucketProtocolV1.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract BucketProtocolV1 is IBucketProtocolV1, Ownable {
    // --------- safe start ---------
    using SafeMath for uint256;
    // --------- safe end ---------

    // --------- permissions start ---------
    address private _owner;
    uint256 private constant MAX_TAX = 5;
    uint256 private _TAX = 1;
    // --------- permissions end ---------

    // --------- work start ---------
    mapping(bytes32 => uint256) private _ethDeposit;
    mapping(bytes32 => mapping(address => uint256)) private _tokenDeposit;
    mapping(address => mapping(address => bool)) private _tokenApproves;
    mapping(address => bytes32[]) private _withdrawCodeList;

    // --------- work start ---------

    constructor() {
        _owner = msg.sender;
    }

    function deposit() external payable override {
        uint256 amount = msg.value;
        require(address(msg.sender) != address(0), "error address");
        require(msg.value != 0, "error amount");
        // create withdraw code
        bytes32 code = _crtWithdrawCode(msg.sender);
        amount = _tax(msg.sender, amount);
        _ethDeposit[code] = _ethDeposit[code].add(amount);
        emit Deposit(msg.sender, amount);
    }

    function depositByWithdrawCode(bytes32 withdrawCode)
        external
        payable
        override
    {
        uint256 amount = msg.value;
        require(address(msg.sender) != address(0), "error address");
        require(msg.value != 0, "error amount");
        amount = _tax(msg.sender, amount);
        bytes32 code = keccak256(abi.encodePacked(withdrawCode));
        _ethDeposit[code] = _ethDeposit[code].add(amount);
        emit Deposit(msg.sender, amount);
    }

    function depositToken(address tokenAddr, uint256 amount) external override {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
        require(Address.isContract(tokenAddr), "Is not a contract address");
        IERC20 _token = IERC20(tokenAddr);
        // approve
        if (!_tokenApproves[msg.sender][tokenAddr]) {
            _token.approve(address(this), amount);
            _tokenApproves[msg.sender][tokenAddr] = true;
        }
        // deposit
        _token.transferFrom(msg.sender, address(this), amount);
        // create withdraw code
        bytes32 code = _crtWithdrawCode(msg.sender);
        amount = _tax(msg.sender, _token, amount);
        _tokenDeposit[code][tokenAddr] = amount;
        emit Deposit(msg.sender, amount);
    }

    function depositTokenByWithdrawCode(
        bytes32 withdrawCode,
        address tokenAddr,
        uint256 amount
    ) external override {}

    function withdrawByWithdrawCode(bytes32 withdrawCode, uint256 amount)
        external
        view
        override
    {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
    }

    function withdrawTokenByWithdrawCode(
        address tokenAddr,
        bytes32 withdrawCode,
        uint256 amount
    ) external override {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
        require(Address.isContract(tokenAddr), "Is not a contract address");
        IERC20 _token = IERC20(tokenAddr);
        _token.transferFrom(address(this), msg.sender, amount);
    }

    function balanceByWithdrawCode(bytes32 withdrawCode)
        external
        view
        override
        returns (uint256)
    {
        return _ethDeposit[withdrawCode];
    }

    function balanceTokenByWithdrawCode(address tokenAddr, bytes32 withdrawCode)
        external
        view
        override
        returns (uint256)
    {
        return _tokenDeposit[withdrawCode][tokenAddr];
    }

    function getWithdrawCodeList()
        external
        view
        override
        returns (bytes32[] memory)
    {
        bytes32[] memory withdrawCodeList = _withdrawCodeList[msg.sender];
        require(withdrawCodeList.length != 0, "No deposit record exists");
        return withdrawCodeList;
    }

    function setTax(uint256 tax) public onlyOwner returns (uint256) {
        require(
            Math.max(tax, MAX_TAX) == MAX_TAX,
            "Exceeded the maximum tax value"
        );
        _TAX = tax;
        return _TAX;
    }

    function _tax(address sender, uint256 amount) private returns (uint256) {
        uint256 tax = amount.mul(_TAX).div(100);
        amount = amount.sub(tax);
        require(payable(address(this)).send(tax), "send error");
        return amount;
    }

    function _tax(
        address sender,
        IERC20 token,
        uint256 amount
    ) private returns (uint256) {
        uint256 tax = amount.mul(2).div(100);
        amount = amount.sub(tax);
        token.transferFrom(sender, address(this), tax);
        return amount;
    }

    function _crtWithdrawCode(address sender) private view returns (bytes32) {
        uint256 r = uint256(
            keccak256(
                abi.encodePacked(block.difficulty, block.timestamp, sender)
            )
        ) % (block.timestamp);
        bytes32 withdrawCode = keccak256(abi.encodePacked(r));
        return withdrawCode;
    }

    fallback() external payable {}

    receive() external payable {}
}
