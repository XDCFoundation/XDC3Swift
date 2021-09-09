# XDC3Swift

## XRC20

To use the XRC20 methods,  run `pod install` .

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
Swift
```
Import XDC3Swift
```
Creating a instance of XRC20. This will provide you access to a set of functions interacting with the blockchain.
```
var client: XDCClient?
var xrc20: XRC20?
client = XDCClient(url: URL(string: "rpc url")!)
xrc20 = XRC20(client: client!)
let account1 = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: testConfig.account1_privateKey))
```
Now, we can interact with the XRC20 read methods.
```
xrc20.decimal(tokenContract: XDCAddress("token address")) { (err, decimal) in
            DispatchQueue.main.async {
                self.Decimal.text = "Decimal : \(decimal!)"
                print("Decimal : \(decimal!)")
            }
        }
```
To interact with write methods in XRC20 .


transfer(address token, address recipient, uint256 amount) → Moves amount tokens from the caller’s account to recipient. It will return a transaction hash.

```
   let function = XRC20Functions.transfer(contract: XinfinAddress("Token address"), to: XinfinAddress("reciever address"), value: BigUInt(amount))
        let transaction = (try? function.transaction(gasPrice: 35000, gasLimit: 30000))!
            client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            print("TX Hash: \(txHash ?? "")")
                tx = txHash!
        }
 ```       

## Author

XDCFoundation, XFLW@xinfin.org

## License

XDC3Swift is available under the MIT license. See the LICENSE file for more info.
