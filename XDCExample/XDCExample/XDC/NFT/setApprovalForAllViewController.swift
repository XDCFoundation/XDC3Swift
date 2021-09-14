//
//  setApprovalForAllViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class setApprovalForAllViewController: UIViewController {
var tokenAddress = ""
    var privateKey = ""
    var account: XDCAccount?
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    @IBOutlet var txhash: UITextView!
    @IBOutlet var boolValue: UITextField!
    @IBOutlet var spenderAddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        // Do any additional setup after loading the view.
    }
    @IBAction func bckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func setApprovalForAllBtn(_ sender: UIButton) {
        let bool = Bool(boolValue.text!)
        let function = XRC721Functions.setApprovalForAll(contract: XDCAddress(tokenAddress), to: XDCAddress(spenderAddress.text!), approved: bool!)
        let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
        self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!) { (err, txhash) in
            DispatchQueue.main.async {
                self.txhash.text = "\(txhash!)"
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
