//
//  TransferViewController.swift
//  CXExample
//
//  Created by Developer on 23/06/21.
//

import UIKit
import XDC3Swift
import BigInt
class TransferViewController: UIViewController {
    var privateKey = ""
    @IBOutlet var enterReceiverAddress: UITextField!
    @IBOutlet var chkAddressBtn: UIButton!
    @IBOutlet var enterPrivateKey: UITextField!
    @IBOutlet var btn: UIButton!
    @IBOutlet var senderAddr: UILabel!
    @IBOutlet var receiverAddr: UILabel!
    @IBOutlet var value: UITextField!
    var account: XDCAccount? = nil
    var txhash = ""
    let receiver = "xdc63b32225813a3f2b877d77094d25f7ce6653b4b5"
    var sender = ""
    
    
    // 0xd596a485cebc97afc2f114286599ff5ac7d62ee907b9543a290a994c6b1de9fb - Example Private Key
    
    //  Creating an instance of XinfinClient. This will then provide access to a set of functions for interacting with the Blockchain.
    
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 7
     //   chkAddressBtn.layer.cornerRadius = 7
        self.setupHideKeyboardOnTap()
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey:    privateKey))
        senderAddr.text = "\(account!.address.value)"
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.enterPrivateKey.text = ""
//        self.enterReceiverAddress.text = ""
//        self.senderAddr.text = "Address"
//        self.value.text = ""
//    }
    
    @IBAction func chkAddressPressed(_ sender: UIButton) {
        
        if self.enterPrivateKey.text!.count < 66 && !(enterPrivateKey.text?.contains("0x"))!  {
            self.enterPrivateKey.text = ""
            self.alert(title: "Alert", msg: "Invalid private key", target: self)
        }else{
            self.account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey:    enterPrivateKey.text!))
            self.sender = "\(account!.address.value)"
            self.senderAddr.text = replaceMiddle(of: self.sender, withCharacter: ".", offset: 12)
        }
    }
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if self.enterReceiverAddress.text!.count < 42 && !(self.enterReceiverAddress.text!.contains("xdc")) && !(self.enterReceiverAddress.text!.contains("0x")) {
            self.enterReceiverAddress.text = ""
            self.alert(title: "Alert", msg: "Enter valid address", target: self)
        }else{
            var rv = self.enterReceiverAddress.text
            if self.enterReceiverAddress.text!.contains("xdc"){
                rv = rv?.xdc3.noxdcPrefix.xdc3.withHexPrefix
            }
            
            if account?.address == nil || self.enterReceiverAddress.text!.count < 42{
                self.alert(title: "Alert", msg: "Receiver address or private key is invalid", target: self)
            }else{
                let val = BigUInt(value.text!)
                let d3 = BigUInt(val! * 1000000000000000000)
                
                let tx = XDCTransaction(from: nil, to: XDCAddress(rv!), value: BigUInt(d3), data: nil, nonce: 3, gasPrice: BigUInt(4000004), gasLimit: BigUInt(50005), chainId: 51)
                client.eth_sendRawTransaction(tx, withAccount: self.account!) { (err, tx) in
                 //   print(tx ?? "no tx")
                    DispatchQueue.main.async {
                        let nStroyBoard: UIStoryboard = UIStoryboard(name: "Maiin", bundle: nil)
                        let XDC3VC = nStroyBoard.instantiateViewController(identifier: "TxHashViewController") as! TxHashViewController
                        XDC3VC.tx = tx!
                        //  print(XDC3VC.tx)
                        self.navigationController?.pushViewController(XDC3VC, animated: true)
                    }
                    self.txhash = tx!
                }
            }
        }
        
    }
    
    @IBAction func bckBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
