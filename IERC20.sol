// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IERC20 {
    // 释放条件: 当value单位的货币从from转账到to时
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 释放条件: 当value单位的货币从owner授权给spender时
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 返回代币总和
    function totalSupply() external view returns(uint256);

    // 返回账户所持代币数
    function balanceOf(address account) external view returns(uint256);

    /*
      调用者转账amount给to账户
      成功返回true
      释放{Transfer}事件
    */
    function transfer(address to, uint256 amount) external returns(bool);
    /*
      返回owner授权给spender的额度, 默认是0
      当调用授权函数如{approve} 或 {transferFrom}, allowance返回值会改变
    */
    function allowance(address owner, address spender) external view returns(uint256);
    /*
      调用者账户给spender授权amount数量的代币
      成功返回true
      释放{Approval}事件
    */
    function approve(address spender, uint256 amount) external returns(bool); 
     /*
      通过授权机制, 从from账户向to账户转账, 转账的部分从调用者的授权额度allowance中扣除
      成功返回true
      释放{Transfer}事件
    */
    function transferFrom(address from, address to, uint256 amount) external returns(bool);

}