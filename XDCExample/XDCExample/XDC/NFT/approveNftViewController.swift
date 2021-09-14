//
//  approveNftViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class approveNftViewController: UIViewController {
    var tokenAddress = ""
    var privateKey = ""
    var account: XDCAccount?
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    @IBOutlet var txhASH: UITextView!
    @IBOutlet var tokenId: UITextField!
    @IBOutlet var spenderAddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: UIButton) {
        let val = BigUInt(tokenId.text!)
        let function = XRC721Functions.approve(contract: XDCAddress(self.tokenAddress), to: XDCAddress(spenderAddress.text!), tokenId: val!)
        let transaction = try? function.transaction(gasPrice: 350000, gasLimit: 300000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.txhASH.text = "\(txhash!)"
            }
        }
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
