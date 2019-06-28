# Ethereum Guide

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


## フロントからスマートコントラクトへの接続  


```test.js

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>Sample Web3</title>
<script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.34/dist/web3.min.js"></script>
<script language="javascript" type="text/javascript">
var web3js = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/fe99efde62d746429dd9159e1bdceaae'));

var balance = web3js.eth.getBalance("0x922b992698381C7dC8d23684E2CAeF396b0b73a4");

balance.then(function(result) {
    console.log("------1")
    console.log(result)
    console.log("------/1")
}).catch(function(error) {console.log(error)});


var abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"INITIAL_SUPPLY","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_name","type":"string"},{"name":"_symbol","type":"string"},{"name":"_decimals","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_burner","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Burn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}];

var address = "0x4BFBa4a8F28755Cb2061c413459EE562c6B9c51b";

var contract = new web3js.eth.Contract(abi, address);

console.log("------2")
console.log(contract);
console.log("------/2")

contract.methods.balanceOf("0x922b992698381C7dC8d23684E2CAeF396b0b73a4").call({from: '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe'}, (error, result) => {
    debugger;
console.log("------3")
console.log(error);
console.log(result);
console.log("------/3")

});

</script>
</head>
<body>
<h1>Sample Page</h1>
</body>

</html>
```


```index.html
<html>
<body>
<script>

const desiredNetwork = '3' // Ethereum Ropsten network ID

// Metamaskがインストールされているか確認
if (typeof window.ethereum === 'undefined') {
  alert('Looks like you need a Dapp browser to get started.')
  alert('Consider installing MetaMask!')

} else {
  window.web3 = new Web3(ethereum);
  // Metamaskを連携させる
  ethereum.enable()

  // Metamask連携を拒否された場合
  .catch(function (reason) {
    if (reason === 'User rejected provider access') {
      // 署名を拒否した場合
    } else {
      alert('There was an issue signing you in.')
    }
  })

  // ユーザが連携を許可した場合、Metamaskのアカウントを取得可能
  .then(function (accounts) {
    // Ropstenにいることを確認
    if (ethereum.networkVersion !== desiredNetwork) {
      alert('This application requires Ropsten network, please switch it in your MetaMask UI.')
    }

    // Metamaskアカウント取得
    const account = accounts[0]
        
    // トランザクション
    //sendEther(account, function (err, transaction) {console.log(transaction)});
    sendTransaction(account, function (err, transaction) {console.log(transaction)});

    // データ取得
    callMethod(function (err, result) {console.log(result)});


  })
}

function callMethod (callback) {
        var abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"INITIAL_SUPPLY","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_name","type":"string"},{"name":"_symbol","type":"string"},{"name":"_decimals","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_burner","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Burn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}];
        var address = "0x4BFBa4a8F28755Cb2061c413459EE562c6B9c51b";
        var contract = web3.eth.contract(abi).at(address);

        try {
          contract.balanceOf.call("0x922b992698381C7dC8d23684E2CAeF396b0b73a4", function(error, result){
            alert("Successufully got data: " + result);
          });
        } catch (error) {
          // User denied account access...
          console.log(error);
        }
}

function sendTransaction (account, callback) {
        var abi = [{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];
        var address = "0xa4d7933660b48bf95a9698fefc6134d18cb77824";
        var contract = web3.eth.contract(abi).at(address);

        try {
          contract.set.sendTransaction("12345", {value: 100000000, from: account}, function(error, result){
            alert("Successuful Transaction: " + result);
          });
        } catch (error) {
          // User denied account access...
          console.log(error);
        }
}

function sendEther (account, callback) {
        try {
            web3.eth.sendTransaction({
            from: account,
            to: '0x9e0ADAb5b514B8c604190B8F6674F2A83A8c17eC',
            value: '200000000000000'}, function(error, result) {
            
            });
        } catch (error) {
          // User denied account access...
          console.log(error);
        }
}

</script>
</body>
</html>

```


## サーバー起動  

Metamaskをローカルで利用する際に必要  

```sh
npm install -g live-server  
cd {適当なディレクトリ}  
vi index.html  
live-server .  
```

## 開発アドバイス  

## 型
- bool: 論理値。true or false 
- struct: 構造体。  
ex) struct Voter {uint weight; bool voted;}
- string: 文字列

## 決済
- （Remixにて）メソッドを実行送金する時にvalueを設定するとコントラクトへの送金も可能  
コントラクトにて、送金者はmsg.sender、金額はmsg.valueで取得できる  
- コントラクトにデポジットされたEtherを引き出すには  
msg.sender.transfer(amount); で可能(msg.sender(引出トランザクションの実行者アドレス)にamount分送金 )

## 抽選
特殊な変数一覧  
https://solidity.readthedocs.io/en/v0.5.0/units-and-global-variables.html#special-variables-and-functions  


## 独自スマートコントラクト開発

※最低要件さえ満たしていればその他の機能は何でもアリです

### 投票  

最小要件  

- 候補数設定（初期化時）  
- 各候補名設定（初期化時）  
- 投票  
- 勝者取得  

オプション例  

- 投票管理者設定  
- 投票権の配布  
- 投票権の重み付け  
- 投票受付締切  


### 決済  

最小要件  

- 販売者アドレス設定（初期化時）  
- 商品種別IDと各価格設定  
- 購入とコントラクトへのデポジット（デポジット額をウォレットアドレス毎に管理）  
- 売上の引出  

オプション例  

- 商品在庫数設定  
- ディスカウントクーポン  
- エスクロー  

### 抽選  

最小要件  

- オーナー設定  
- 抽選開始  
- 抽選参加  
- 抽選受付終了  
- ランダム選択、当選者決定


## 正解例  

Solidityのバージョンを0.4.24にして実行下さい

- 投票  
<https://github.com/TECHFUND/ethereum-doc/blob/master/Voting.sol>  

- 決済  
<https://github.com/TECHFUND/ethereum-doc/blob/master/Payment.sol>  

- 抽選  
<https://github.com/TECHFUND/ethereum-doc/blob/master/Lottery.sol>  


# トークン発行

## デフォルトERC20トークン
- 全体ソース  
<https://github.com/TECHFUND/ethereum-doc/blob/master/Token_Whole.sol>  

- 圧縮版ソース  
<https://github.com/TECHFUND/ethereum-doc/blob/master/Token.sol>  

## ライブラリ
OpenZeppelin  
- ドキュメント全体  
<https://docs.openzeppelin.org/>  

- トークン  
<https://docs.openzeppelin.org/v2.3.0/tokens> 
<https://docs.openzeppelin.org/v2.3.0/api/token/erc20>  

- クラウドセール  
<https://docs.openzeppelin.org/v2.3.0/crowdsales>  

## 言語補足  

- 修飾子
関数の実行に制約を付ける  
```sol
modifier onlyMinter() {
    require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
    _;
}
function mint(address account, uint256 amount) public onlyMinter returns (bool) {
```

<https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/roles/MinterRole.sol>  

## 追加機能  
- Mintable  
トークンを追加発行可能にする　　
<https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Mintable.sol>  

- Burnable  
トークンをBurn(発行数を減らす)可能にする  
<https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Burnable.sol>  



Hayakawa Mail Address  
yi_hayakawa@techfund.jp 

