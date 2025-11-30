// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

/*
合约包含以下标准 ERC20 功能：
1. balanceOf：查询账户余额。
2. transfer：转账。
3. approve 和 transferFrom：授权和代扣转账。
4. 使用 event 记录转账和授权操作。
5. 提供 mint 函数，允许合约所有者增发代币。  ✅

使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
*/
contract ERC20 is IERC20 {
    
    // 1. balanceOf：查询账户余额。
    mapping(address => uint256) public override balanceOf;
    // 授权账户余额
    mapping(address => mapping(address => uint256)) public override allowance;
    // 代币总供给
    uint256 public override totalSupply;

    // 合约所有者
    address public owner;
    // 合约名称和符号
    string public name; 
    string public symbol;
    uint8 public immutable decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
    }

    // 2. transfer：转账。
    function transfer(address to, uint256 amount) public override returns(bool) {
        // valid
        require(to != address(0), "to address is 0");
        require(balanceOf[msg.sender] >= amount, "balance is not enough");
        // execu
        _transfer(msg.sender, to, amount);
        return true;
    }
    // 内部函数
    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    // 3. approve：授权
    function approve(address spender, uint256 amount) public override returns(bool) {
        require(spender != address(0), "spender address is 0");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    // 3. transferFrom：代扣转账。
    function transferFrom(address from, address to, uint256 amount) public override returns(bool) {
        require(from != address(0), "from address is 0");
        require(to != address(0), "to address is 0");
        require(balanceOf[from] >= amount, "from amount is not enough");
        require(allowance[from][msg.sender] >= amount, "approve amount is not enough");
        // 扣减授权额度
        allowance[from][msg.sender] -= amount;
        // execu
        _transfer(from, to, amount);

        return true;
    }


    // 5. 提供 mint 函数，允许合约所有者增发代币。
    function mint(uint256 amount) external onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
    // 控制权限
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call");
        _;
    }

}