//
//  XRC721DetailViewController.swift
//  XDCExample
//
//  Created by Developer on 01/07/21.
//

import UIKit
import XDC3Swift
import BigInt
class XRC721DetailViewController: UIViewController {
    let tokenOwner = XDCAddress("xdc69F84b91E7107206E841748C2B52294A1176D45e")
    let previousOwner = XDCAddress("xdc64d0ea4fc60f27e74f1a70aa6f39d403bbe56793")
    let nonOwner = XDCAddress("xdc64d0eA4FC60f27E74f1a70Aa6f39D403bBe56792")
    let nftImageURL = URL(string: "https://ipfs.io/ipfs/QmUDJMmiJEsueLbr6jxh7vhSSFAvjfYTLC64hgkQm1vH2C/graph.svg")!
    let nftURL = URL(string: "https://ipfs.io/ipfs/QmUtKP7LnZnL2pWw2ERvNDndP9v5EPoJH7g566XNdgoRfE")!
    @IBOutlet var xdc_address: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var PrivateKey: UITextField!
    
    
    // XRC721 standards
    @IBOutlet var name: UILabel!
    
    @IBOutlet var balanceOf: UILabel!
    @IBOutlet var balanceOfAddressTF: UITextField!
    
    @IBOutlet var totalSupply: UILabel!
    @IBOutlet var symbol: UILabel!
    
    @IBOutlet var getApproved: UITextView!
    @IBOutlet var getApprovedTokenIdTF: UITextField!
    
    @IBOutlet var isApprovedForAll: UITextView!
    @IBOutlet var isApprovedOwnerTF: UITextField!
    @IBOutlet var isApprovedOperatorTF: UITextField!

    @IBOutlet var OwnerOf: UILabel!
    @IBOutlet var OwnerOfTokenIdTF: UITextField!
    
    @IBOutlet var supportInterface: UITextView!
    @IBOutlet var supportInterfaceIdTF: UITextField!
    
    @IBOutlet var approve: UITextView!
    @IBOutlet var approveToTF: UITextField!
    @IBOutlet var approveTokenIdTF: UITextField!
    
    
    @IBOutlet var safeTransferFrom: UITextView!
    @IBOutlet var STFfromTF: UITextField!
    @IBOutlet var STFtoTF: UITextField!
    @IBOutlet var STFtokenTF: UITextField!
    
    @IBOutlet var setApprovalForAll: UITextView!
    @IBOutlet var SAtoTF: UITextField!
    @IBOutlet var SAapprovedTF: UITextField!
    
    @IBOutlet var TransferFrom: UITextView!
    @IBOutlet var TFfromTF: UITextField!
    @IBOutlet var TFtoTF: UITextField!
    @IBOutlet var TFtokenidTF: UITextField!
    
    @IBOutlet var tokenURI: UITextView!
    @IBOutlet var tokenURItokenID: UITextField!
    
    @IBOutlet var tokenOfOwnerByIndex: UITextView!
    @IBOutlet var TOIownerTF: UITextField!
    @IBOutlet var TOIindexTF: UITextField!
    
    @IBOutlet var tokenByIndex: UITextView!
    @IBOutlet var TIindexTF: UITextField!
    var client: XDCClient!
    var xrc721: XRC721!
    var xrc721Metadata: XRC721Metadata!
    var xrc721Enumerable: XRC721Enumerable!
    var xinfinAddress = ""
    var account: XDCAccount?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dotted = replaceMiddle(of: xinfinAddress, withCharacter: ".", offset: 12)
        xdc_address.text = dotted
    //    address.text = xinfinAddress
        self.client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
        self.xrc721 = XRC721(client: client)
        self.xrc721Metadata = XRC721Metadata(client: client, metadataSession: URLSession.shared)
        self.xrc721Enumerable = XRC721Enumerable(client: client)
        // Do any additional setup after loading the view.
        setup()
        self.setupHideKeyboardOnTap()
    }
    func setup(){
        xrc721Metadata.name(contract: XDCAddress(xinfinAddress)) { (err, tokenName) in
            DispatchQueue.main.async {
                self.name.text = "Name : \(tokenName!)"
            }
        }
        xrc721Metadata.symbol(contract: XDCAddress(xinfinAddress)) { (err, tokenSymbol) in
            DispatchQueue.main.async {
                self.symbol.text = "Symbol : \(tokenSymbol!)"
            }
        }
        xrc721Enumerable.totalSupply(contract: XDCAddress(xinfinAddress)) { (err, supply) in
            DispatchQueue.main.async {
                self.totalSupply.text = "totalSupply : \(supply!)"
            }
        }
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ChkAddressBtn(_ sender: UIButton) {
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: PrivateKey.text!))
        self.address.text = "\(account!.address.value)"
    }
    
    @IBAction func balanceOfBtn(_ sender: UIButton) {
        xrc721.balanceOf(contract: XDCAddress(xinfinAddress), address: XDCAddress(balanceOfAddressTF.text!)) { (err, balanceOf) in
            DispatchQueue.main.async {
                self.balanceOf.text = "balanceOf : \(balanceOf!)"
            }
        }
    }
    
    @IBAction func OwnerOfTF(_ sender: Any) {
        let tokenId = BigUInt(OwnerOfTokenIdTF.text!)!
        xrc721.ownerOf(contract: XDCAddress(xinfinAddress), tokenId: tokenId) { (err, addr) in
            DispatchQueue.main.async {
                self.OwnerOf.text = "OwnerOf : \(addr!.value)"
            }
        }
    }
    
    @IBAction func getApprovedBTn(_ sender: UIButton) {
        let tokenId = BigUInt(getApprovedTokenIdTF.text!)!
        xrc721.getApproved(contract: XDCAddress(xinfinAddress), tokenId: tokenId) { (err, addr) in
            DispatchQueue.main.async {
                self.getApproved.text = "getApproved : \(addr!.value)"
            }
        }
    }
    @IBAction func isApprovedForAll(_ sender: UIButton) {
        xrc721.isApprovedForAll(contract: XDCAddress(xinfinAddress), opearator: XDCAddress(isApprovedOperatorTF.text!), owner: XDCAddress(isApprovedOwnerTF.text!)) { (error, value) in
            DispatchQueue.main.async {
                self.isApprovedForAll.text = "isApprovedForAll : \(value!)"
            }
        }
    }
    @IBAction func supportInterfaceBtn(_ sender: UIButton) {
        let data = supportInterfaceIdTF.text
        xrc721.supportsInterface(contract: XDCAddress(xinfinAddress), id: (data?.xdc3.hexData)!) { (err, value) in
            DispatchQueue.main.async {
                self.supportInterface.text = "SupportInterface : \(value!)"
            }
        }
    }
    @IBAction func approveBtn(_ sender: UIButton) {
        let val = BigUInt(approveTokenIdTF.text!)
        let function = XRC721Functions.approve(contract: XDCAddress(xinfinAddress), to: XDCAddress(approveToTF.text!), tokenId: val!)
        let transaction = try? function.transaction(gasPrice: 350000, gasLimit: 300000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.approve.text = "Approve : \(txhash!)"
            }
        }
    }
    @IBAction func safeTransferFromBtn(_ sender: UIButton) {
        let val = BigUInt(STFtokenTF.text!)
        let function = XRC721Functions.safeTransferFrom(contract: XDCAddress(xinfinAddress), sender: XDCAddress(STFfromTF.text!), to: XDCAddress(STFtoTF.text!), tokenId: val!)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.safeTransferFrom.text = "SafeTransferFrom : \(txhash!)"
            }
        }
    }
    @IBAction func setApprovalForAllBtn(_ sender: UIButton) {
        let bool = Bool(SAapprovedTF.text!)
        let function = XRC721Functions.setApprovalForAll(contract: XDCAddress(xinfinAddress), to: XDCAddress(SAtoTF.text!), approved: bool!)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.setApprovalForAll.text = "setApprovalForAll : \(txhash!)"
            }
        }
    }
    @IBAction func TransferFromBtn(_ sender: UIButton) {
        let val = BigUInt(TFtokenidTF.text!)
        let function = XRC721Functions.transferFrom(contract: XDCAddress(xinfinAddress), sender: XDCAddress(TFfromTF.text!), to: XDCAddress(TFtoTF.text!), tokenId: val!)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.TransferFrom.text = "TransferFrom : \(txhash!)"
            }
        }
    }
    
    @IBAction func tokenByInedexBtn(_ sender: UIButton) {
        let index = BigUInt(TIindexTF.text!)
        xrc721Enumerable.tokenByIndex(contract: XDCAddress(xinfinAddress), index: index!) { (err, token) in
            DispatchQueue.main.async {
                self.tokenByIndex.text = "tokenByIndex : \(token!)"
            }
        }
    }
    @IBAction func tokenURIBtn(_ sender: UIButton) {
        let index = BigUInt(tokenURItokenID.text!)
        xrc721Metadata.tokenURI(contract: XDCAddress(xinfinAddress), tokenID: index!) { (err, url) in
            DispatchQueue.main.async {
                self.tokenURI.text = "tokenURI : \(url!)"
            }
        }
    }
    @IBAction func tokenOfOwnerByIndexBtn(_ sender: UIButton) {
        let index = BigUInt(TOIindexTF.text!)
        xrc721Enumerable.tokenOfOwnerByIndex(contract: XDCAddress(xinfinAddress), owner: XDCAddress(TOIownerTF.text!), index: index!) { (err, token) in
            DispatchQueue.main.async {
                self.tokenOfOwnerByIndex.text = "tokenOfOwnerByIndex : \(token!)"
            }
        }
    }
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
