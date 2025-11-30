// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/*
任务目标
1. 使用 Solidity 编写一个符合 ERC721 标准的 NFT 合约。
2. 将图文数据上传到 IPFS，生成元数据链接。
3. 将合约部署到以太坊测试网（如 Goerli 或 Sepolia）。
4. 铸造 NFT 并在测试网环境中查看。
*/
contract NFT is ERC721 {

    uint256 private _nextTokenId = 0;
    mapping(uint256 => string) private _tokenURIs;

    // 合约所有者
    address public owner;

    // 1-1: 构造函数：设置 NFT 的名称和符号。 
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        owner = msg.sender;
    }

    // 1-2: mintNFT 函数：允许用户铸造 NFT，并关联元数据链接（tokenURI）
    function mintNFT(address to, string memory _tokenURI) public onlyOwner returns(uint256) {
        uint256 tokenId = _nextTokenId;
        _nextTokenId += 1;

        _safeMint(to, tokenId);
        _tokenURIs[tokenId] = _tokenURI;

        return tokenId;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call");
        _;
    }

    // 给钱包用于获取图片等信息
    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        _requireOwned(tokenId);
        return _tokenURIs[tokenId];
    }

}
