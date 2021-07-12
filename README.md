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

## Author

XinFin, XFLW@xinfin.org

## License

XDC3Swift is available under the MIT license. See the LICENSE file for more info.
