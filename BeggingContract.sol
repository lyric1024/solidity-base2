// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
任务目标
1. 使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
2. 记录每个捐赠者的地址和捐赠金额。
3. 允许合约所有者提取所有捐赠的资金
*/
contract BeggingContract {

    address public owner; // 合约拥有者
    uint256 public totalDonated; // 捐赠总额

    // 一个 mapping 来记录每个捐赠者的捐赠金额。
    mapping(address => uint256) public userDonation;
    // 捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
    event Donation(address indexed donor, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable { 
        donate();
    }
    
    // 一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
    function donate() public payable {
        // 增加startTime & endTime, donate时检查block.timestamp进行限制. 测试不麻烦, 考虑不予实现
        require(msg.value > 0, "donate amount must bigger than 0");
        userDonation[msg.sender] += msg.value;
        totalDonated += msg.value;

        emit Donation(msg.sender, msg.value);
    }

    // 一个 withdraw 函数，允许合约所有者提取所有资金。
    function withdraw() public onlyOwner {
        // 使用 payable 修饰符和 address.transfer 实现支付和提款。
        payable(owner).transfer(address(this).balance);
    }

    // 一个 getDonation 函数，允许查询某个地址的捐赠金额。
    function getDonation(address _addr) public view returns(uint256) {
        return userDonation[_addr];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call");
        _;
    }

}