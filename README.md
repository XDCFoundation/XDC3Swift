# XDC3Swift

[![Version](https://img.shields.io/cocoapods/v/XDC3Swift.svg?style=flat)](https://cocoapods.org/pods/XDC3Swift)
[![License](https://img.shields.io/cocoapods/l/XDC3Swift.svg?style=flat)](https://cocoapods.org/pods/XDC3Swift)
[![Platform](https://img.shields.io/cocoapods/p/XDC3Swift.svg?style=flat)](https://cocoapods.org/pods/XDC3Swift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XDC3Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XDC3Swift'
```
bash

```
$ pod install
```
Getting Started Create an instance of XDCAccount with a XDCKeyStorage provider. This provides a wrapper around your key for use.

Swift
```
Import XDC3Swift
```
Creating a XDC account
```
let keyStorage = XDCKeyLocalStorage()
let account = try? XDCAccount.create(keyStorage: keyStorage, keystorePassword: "MY_PASSWORD")
```
Create an instance of XDCClient. This will provide you access to a set of functions interacting with the blockchain.
```
guard let clientUrl = URL(string: "https://apothem-or-mainnet-url") else { return }
let client = XDCClient(url: clientUrl)
```
You can then interact with the client methods, such as to get the current gas price:
```
client.eth_gasPrice { (error, currentPrice) in
    print("The current gas price is \(currentPrice)")
}
```
Creating an instance of XRC20
```
let xdcClient = XRC20.init(client: XDCClient(url: clientUrl!))
```
Now, we can interact with the XRC20 methods
```
xdcClient.decimal(tokenContract: XDCAddress(xdcAddress)) { (err, decimal) in
            DispatchQueue.main.async {
                self.Decimal.text = "Decimal : \(decimal!)"
                print("Decimal : \(decimal!)")
            }
        }
```
Transfer XDC For transferring XDC from one account to another, we must have the private key of the sender address.
```
let account = try! XDCAccount.init(keyStorage: XDCPrivateKeyStore(privateKey: "privateKey"))
```
We need to create an instance of XDCTransaction with values we want to send to the account.
```
let tx = XDCTransaction(from: nil, to: XDCAddress(xdcAddress), value: BigUInt(value), data: nil, nonce: 3, gasPrice: BigUInt(4000004), gasLimit: BigUInt(50005), chainId: 51)
```
Now, we need to call the eth_sendRawTransaction method.
```
client.eth_sendRawTransaction(tx, withAccount: self.account!) { (err, tx) in
     print(tx ?? "no tx")
 ```    
 
We will receive one txHash which will include all data of the transaction.

### XRC20 Read methods

Creating an instance of XRC20
```
let xdcClient = XRC20.init(client: XDC(url: URL(string: "rpc url")!))
```

Now, we can interact with the XRC20 read methods.

name() → string Returns the name of the token.
```
xdcClient.name(tokenContract: XDCAddress("Token address")) { (err, name) in
                print("Name of token : \(name!)")
        }
```        
balanceOf(address token,address account) → uint256  Returns the amount of tokens owned by account.
```
xdcClient.balanceOf(tokenContract: XDCAddress("Token address"), account: XDCAddress("Token Holder Address")) { (error, balanceOf) in
               print("balance of token wned by account : \(balanceOf)")
        }
  }
```
### XRC20 Write methods

For write methods, we need to create an instance of XDCClient and we need token owner private key
```
let client = XDCClient(url: URL(string: "rpc url")!)
let account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: "owner private key"))
```

transfer(address token, address recipient, uint256 amount) → Moves amount tokens from the caller’s account to recipient. It will return a transaction hash.
```
   let function = XRC20Functions.transfer(contract: XDCAddress("Token address"), to: XDCAddress("reciever address"), value: BigUInt(amount))
        let transaction = (try? function.transaction(gasPrice: 35000, gasLimit: 30000))!
            client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")
                tx = txHash!
        }
 ```       
approve(address token, address spender, uint256 amount) → Sets amount as the allowance of spender over the caller’s tokens. It will return a transaction hash.

```
let function = XRC20Functions.approve(contract: XDCAddress("Token address"), spender: XDCAddress("Spender address"), value: val!)
        let transaction = (try? function.transaction(gasPrice: 35000, gasLimit: 30000))!
            self.client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")   
}
``` 

#### For increaseAllowance and decreaseAllowance we need an instance of XRC20 and private key of owner: 
 
increaseAllowance(XifninAccount account, address token, address owner, address spender, uint256 subtractedValue)
Automically increases the allowance granted to spender by the caller.

This is an alternative to approve.

Emits an Approval event indicating the updated allowance.

```
xdcClient.increaseAllowance(account: self.account!, tokenAddress: XDCAddress("Token Address"), owner: XDCAddress("Owner address"), spender: XDCAddress("Spender address"), value: BigUInt(value), completion: { (txHash) in
            print(txHash!)
    })
```    
### XRC721

XDC3Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Creating a instance of XRC721. This will provide you access to a set of functions interacting with the blockchain.
```
var client: XDCClient?
var xrc721: XRC721!
var xrc721Metadata: XRC721Metadata!
var xrc721Enumerable: XRC721Enumerable!
client = XDCClient(url: URL(string: "rpc url")!)
xrc721 = XRC721(client: client)
xrc721Metadata = XRC721Metadata(client: client, metadataSession: URLSession.shared)
xrc721Enumerable = XRC721Enumerable(client: client)
let account1 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account1_privateKey))
```
Now, we can interact with the XRC721 read methods.
```
xrc721Metadata.name(contract: XDCAddress(address)) { (err, tokenName) in
    DispatchQueue.main.async {
        self.name.text = "Name : \(tokenName!)"
    }
}
xrc721Metadata.symbol(contract: XDCAddress(address)) { (err, tokenSymbol) in
    DispatchQueue.main.async {
        self.symbol.text = "Symbol : \(tokenSymbol!)"
    }
}
xrc721Enumerable.totalSupply(contract: XDCAddress(address)) { (err, supply) in
    DispatchQueue.main.async {
        self.totalSupply.text = "totalSupply : \(supply!)"
    }
}
```
### XRC721 write methods

safeTransferFrom(contract: tokenAddress, sender: fromAddress, to: toAddress, tokenId: id) → Moves the ownership of token from the caller’s account to recipient. It will return a transaction hash.

```
let function = XRC721Functions.safeTransferFrom(contract: self.testTokenAddress, sender: self.testAccount1, to: self.testAccount2, tokenId: 23)
let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
self.client.eth_sendRawTransaction(transaction!, withAccount: self.account1) { (err, txhash) in
   print(txhash)
}
 ```   
## Author

XDCFoundation, XFLW@xinfin.org

## License

XDC3Swift is available under the MIT license. See the LICENSE file for more info.
