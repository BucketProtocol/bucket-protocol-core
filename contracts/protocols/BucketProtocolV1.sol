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
    mapping(string => uint256) private _ethDeposit;
    mapping(string => mapping(address => uint256)) private _tokenDeposit;
    mapping(address => mapping(address => bool)) private _tokenApproves;
    mapping(address => string[]) private _withdrawCodeList;

    // --------- work start ---------

    constructor() {
        _owner = msg.sender;
    }

    function deposit(uint256 amount) public returns (string memory, uint256) {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
        // create withdraw code
        string memory code = _crtWithdrawCode();
        _ethDeposit[code] = _ethDeposit[code].add(amount);
        return (code, _ethDeposit[code]);
    }

    function deposit(string memory withdrawCode, uint256 amount)
        public
        returns (string memory, uint256)
    {}

    function deposit(address tokenAddr, uint256 amount)
        public
        returns (string memory, uint256)
    {
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
        string memory code = _crtWithdrawCode();
        _tokenDeposit[code][tokenAddr] = amount;
        return (code, amount);
    }

    function deposit(
        string memory withdrawCode,
        address tokenAddr,
        uint256 amount
    ) public returns (string memory, uint256) {}

    function withdraw(string memory withdrawCode, uint256 amount)
        public
        returns (uint256)
    {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
    }

    function withdraw(
        address tokenAddr,
        string memory withdrawCode,
        uint256 amount
    ) public returns (uint256) {
        require(address(msg.sender) != address(0), "error address");
        require(amount != 0, "error amount");
        require(Address.isContract(tokenAddr), "Is not a contract address");
        IERC20 _token = IERC20(tokenAddr);
        _token.transferFrom(address(this), msg.sender, amount);
    }

    function balance(string memory withdrawCode) public view returns (uint256) {
        return _ethDeposit[withdrawCode];
    }

    function balance(address tokenAddr, string memory withdrawCode)
        public
        view
        returns (uint256)
    {
        return _tokenDeposit[withdrawCode][tokenAddr];
    }

    function getWithdrawCodeList(address msgSender)
        external
        view
        returns (string[] memory)
    {
        string[] memory withdrawCodeList = _withdrawCodeList[msgSender];
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

    function _crtWithdrawCode() private pure returns (string memory) {
        return "qiwuyeriqwuiehui231hiu4iuewnifuqnweirquiwe";
    }

    function _verifyWithdrawCode(string memory withdrawCode)
        private
        pure
        returns (bool)
    {
        return true;
    }
}
