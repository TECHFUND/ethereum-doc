# ethereum-doc

## Pre-install

講義で行うEthereum開発環境構築に当たり、事前に必要な環境について記載します  

- Node.js  
https://nodejs.org/en/  
からダウンロードしてインストーラ実行し、デフォルト設定で完了する  
- Git for Windows  
https://gitforwindows.org/  
からダウンロードしてインストーラ実行し、デフォルト設定で完了する  

- Chrome  
https://www.google.com/intl/ja/chrome/  

## Install  

### Gethインストール
https://geth.ethereum.org/downloads/  

```sh
$ geth help 
```

日本語名やスペースが入っていないディレクトリに移動

```sh
mkdir /c/Users/henma/Documents/ethereum/geth  
cd /c/Users/henma/Documents/ethereum/geth  
```

上記ディレクトリに以下genesis.jsonを配置
```genesis.json
{
  "config": {
    "chainId": 33,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "nonce": "0x0000000000000033",
  "timestamp": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0x8000000",
  "difficulty": "0x100",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x3333333333333333333333333333333333333333",
  "alloc": {}
}
```

```sh
$ geth --datadir ./private init ./genesis.json
```

Successfully wrote genesis stateと表示されればOK

```sh
$ geth --networkid 33 --datadir ./private --maxpeers 0 --nodiscover console 2>> node.log


eth.getBlock(0)

personal.newAccount("password1")
personal.newAccount("password2")
personal.newAccount("password3")

eth.accounts
eth.coinbase

miner.start(1)
eth.mining

しばらく待つ

eth.blockNumber
eth.hashrate
eth.getBlock(50)

eth.getBalance(eth.coinbase)
web3.fromWei(eth.getBalance(eth.coinbase), "ether")

eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei("1", "ether")})


※Error: authentication needed: password or unlockと出ます

personal.unlockAccount(eth.accounts[0], "password1")
eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei("1", "ether")})

eth.getBalance(eth.accounts[1])
web3.fromWei(eth.getBalance(eth.accounts[1]), "ether")

personal.unlockAccount(eth.accounts[1], "password2")
eth.sendTransaction({from: eth.accounts[1], to: eth.accounts[2], value: web3.toWei("0.5", "ether")})

web3.fromWei(eth.getBalance(eth.accounts[1]), "ether")
web3.fromWei(eth.getBalance(eth.accounts[2]), "ether")

eth.getTransaction("0xc4028651a43a3be000ddd98d5fd383e3daf172f5bec3b5e597349fea68fede81")
※ハッシュ値は直前に行ったeth.sendTransactionの結果を入れる

結果のblockHashの値を確認して、当該Blockの情報を取得する
eth.getBlock("0x288a02f79124483c74684b810875a1a6ec9c87eae436304c0c25bf230c507cea")


eth.gasPrice
web3.toWei("0.5", "ether") - 21000 * eth.gasPrice
eth.getBalance(eth.accounts[1])

```

### Meatamaskインストール  
https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=ja

### Testnet (Ropsten)用 Ether取得  
https://faucet.ropsten.be/  

### Remix
https://remix.ethereum.org/#optimize=false



## Reference

- Solidity  
Ethereumのスマートコントラクト開発において最も代表的な言語  
https://solidity.readthedocs.io/en/v0.5.3/  

- Web3.js  
Ethereumノードとの通信に必要なJSライブラリ　※他言語用にもそれぞれ存在  
https://web3js.readthedocs.io/en/1.0/  


## サンプルコードを通じたSolidity学習

- 解説用スマートコントラクト1  

```simpleStorage.sol
pragma solidity >=0.4.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```


- 解説用スマートコントラクト2  

```simpleCoin.sol
pragma solidity ^0.5.0;

contract Coin {
    // The keyword "public" makes those variables
    // easily readable from outside.
    address public minter;
    mapping (address => uint) public balances;

    // Events allow light clients to react to
    // changes efficiently.
    event Sent(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
```


Hayakawa Mail Address  
yi_hayakawa@techfund.jp  

