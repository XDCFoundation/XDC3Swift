//
//  safeTransferFromViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class safeTransferFromViewController: UIViewController {
    @IBOutlet var txHash: UITextView!
    var privateKey = ""
    var tokenAddress = ""
    @IBOutlet var fromAddress: UITextField!
    @IBOutlet var toAddress: UITextField!
    @IBOutlet var tokenId: UITextField!
    var account: XDCAccount?
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
      
        // Do any additional setup after loading the view.
    }
    @IBAction func bckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   

    @IBAction func send(_ sender: Any) {
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        let val = BigUInt(tokenId.text!)
        let function = XRC721Functions.safeTransferFrom(contract: XDCAddress(tokenAddress), sender: XDCAddress(fromAddress.text!), to: XDCAddress(toAddress.text!), tokenId: val!)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.txHash.text = "\(txhash!)"
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
