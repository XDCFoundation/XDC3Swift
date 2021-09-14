//
//  tokenTransferViewController.swift
//  XDCExample
//
//  Created by Developer on 16/08/21.
//

import UIKit
import BigInt
import XDC3Swift
class tokenTransferViewController: UIViewController {
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    var account: XDCAccount?
    var privateKey = ""
    var tokenAddress = ""
   
    @IBOutlet var transactionHash: UITextView!
    @IBOutlet var toAddress: UITextField!
    @IBOutlet var value: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
         account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tokenTransfer(_ sender: UIButton) {
      //  print("address: \(account?.address) tokenaddress: \(tokenAddress) toAddress: \(toAddress.text)")
        let val = BigUInt(value.text!)
        let function = XRC20Functions.transfer(contract: XDCAddress(tokenAddress), to: XDCAddress(toAddress.text!), value: val!)
        let transaction = (try? function.transaction(gasPrice: 350000, gasLimit: 300000))!
        client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
            DispatchQueue.main.async {
                self.transactionHash.text = "\(txHash!)"
                print("TX Hash: \(txHash ?? "")")
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
