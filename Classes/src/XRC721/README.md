# XDC3Swift

## XRC721

To use the XRC721 methods,  run `pod install` .

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
To interact with write methods in XRC721 .

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
