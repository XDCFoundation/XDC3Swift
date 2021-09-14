//
//  transferFromViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class transferFromViewController: UIViewController {
    var tokenAddress = ""
    var account: XDCAccount?
    @IBOutlet var txHash: UITextView!
    @IBOutlet var callerPrivateKey: UITextField!
    @IBOutlet var fromAddress: UITextField!
    @IBOutlet var toAddress: UITextField!
    @IBOutlet var value: UITextField!
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    override func viewDidLoad() {
        super.viewDidLoad()
       setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    //
    @IBAction func bckBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: callerPrivateKey.text!))
        DispatchQueue.main.async {
            let val = BigUInt(self.value.text!)
            let function = XRC20Functions.transferFrom(contract: XDCAddress(self.tokenAddress), sender: XDCAddress(self.fromAddress.text!), to: XDCAddress(self.toAddress.text!), value: val!)
            let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
            
            self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!, completion: { (error, txhash) in
                DispatchQueue.main.async {
                    self.txHash.text = "\(txhash!)"
                }   
            })
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
