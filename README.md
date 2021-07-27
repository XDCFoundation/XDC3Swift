# XDC3Swift

[![CI Status](https://img.shields.io/travis/angshuman2611/XDC3Swift.svg?style=flat)](https://travis-ci.org/angshuman2611/XDC3Swift)
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
Getting Started Create an instance of XinfinAccount with a XinfinKeyStorage provider. This provides a wrapper around your key for use.

Swift
```
Import XDC3Swift
```
Creating a XinFin account
```
let keyStorage = XinfinKeyLocalStorage()
let account = try? XinfinAccount.create(keyStorage: keyStorage, keystorePassword: "MY_PASSWORD")
```
Create an instance of XinfinClient. This will provide you access to a set of functions interacting with the blockchain.
```
guard let clientUrl = URL(string: "https://apothem-or-mainnet-url") else { return }
let client = XinfinClient(url: clientUrl)
```
You can then interact with the client methods, such as to get the current gas price:
```
client.eth_gasPrice { (error, currentPrice) in
    print("The current gas price is \(currentPrice)")
}
```
Creating an instance of XRC20
```
let xinfinClient = XRC20.init(client: XinfinClient(url: clientUrl!))
```
Now, we can interact with the XRC20 methods as in XDC Network - SDK:iOS - Technical Document | XRC20
```
xinfinClient.decimal(tokenContract: XinfinAddress(xinfinAddress)) { (err, decimal) in
            DispatchQueue.main.async {
                self.Decimal.text = "Decimal : \(decimal!)"
                print("Decimal : \(decimal!)")
            }
        }
```
Transfer XDC For transferring XDC from one account to another, we must have the private key of the sender address.
```
let account = try! XinfinAccount.init(keyStorage: XinfinPrivateKeyStore(privateKey: "privateKey"))
```
We need to create an instance of XinfinTransaction with values we want to send to the account.
```
let tx = XinfinTransaction(from: nil, to: XinfinAddress(xinfinAddress), value: BigUInt(value), data: nil, nonce: 3, gasPrice: BigUInt(4000004), gasLimit: BigUInt(50005), chainId: 51)
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
let xinfinClient = XRC20.init(client: XinfinClient(url: URL(string: "rpc url")!))
```

Now, we can interact with the XRC20 read methods.

name() → string Returns the name of the token.
```
xinfinClient.name(tokenContract: XinfinAddress("Token address")) { (err, name) in
                print("Name of token : \(name!)")
        }
```        
balanceOf(address token,address account) → uint256  Returns the amount of tokens owned by account.
```
xinfinClient.balanceOf(tokenContract: XinfinAddress("Token address"), account: XinfinAddress("Token Holder Address")) { (error, balanceOf) in
               print("balance of token wned by account : \(balanceOf)")
        }
  }
```
### XRC20 Write methods

For write methods, we need to create an instance of XinfinClient and we need token owner private key
```
let client = XinfinClient(url: URL(string: "rpc url")!)
let account = try? XinfinAccount(keyStorage: XinfinPrivateKeyStore(privateKey: "owner private key"))
```

transfer(address token, address recipient, uint256 amount) → Moves amount tokens from the caller’s account to recipient. It will return a transaction hash.
```
   let function = XRC20Functions.transfer(contract: XinfinAddress("Token address"), to: XinfinAddress("reciever address"), value: BigUInt(amount))
        let transaction = (try? function.transaction(gasPrice: 35000, gasLimit: 30000))!
            client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")
                tx = txHash!
        }
 ```       
approve(address token, address spender, uint256 amount) → Sets amount as the allowance of spender over the caller’s tokens. It will return a transaction hash.

```
let function = XRC20Functions.approve(contract: XinfinAddress("Token address"), spender: XinfinAddress("Spender address"), value: val!)
        let transaction = (try? function.transaction(gasPrice: 35000, gasLimit: 30000))!
            self.client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")   
}
``` 

For increaseAllowance and decreaseAllowance we need an instance of XRC20 and private key of owner: 
 
decreaseAllowance(XifninAccount account, address token, address owner, address spender, uint256 subtractedValue)
Automically decreases the allowance granted to spender by the caller.

This is an alternative to approve.

Emits an Approval event indicating the updated allowance.

```
xinfinClient.increaseAllowance(account: self.account!, tokenAddress: XinfinAddress("Token Address"), owner: XinfinAddress("Owner address"), spender: XinfinAddress("Spender address"), value: BigUInt(value), completion: { (txHash) in
            print(txHash!)
    })
```    

## Author

XDCFoundation, XFLW@xinfin.org

## License

XDC3Swift is available under the MIT license. See the LICENSE file for more info.
