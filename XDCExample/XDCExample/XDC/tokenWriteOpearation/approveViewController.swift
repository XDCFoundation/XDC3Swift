//
//  approveViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class approveViewController: UIViewController {
    var tokenAddress = ""
    var privateKey = ""
    var account: XDCAccount?
    @IBOutlet var txhash: UITextView!
    @IBOutlet var spenderAddress: UITextField!
    @IBOutlet var value: UITextField!
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
         

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func approveBtn(_ sender: Any) {
        let val = BigUInt(self.value.text!)
        var tx = ""
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        DispatchQueue.main.async {
            let function = XRC20Functions.approve(contract: XDCAddress(self.tokenAddress), spender: XDCAddress(self.spenderAddress.text!), value: val!)
            let transaction = (try? function.transaction(gasPrice: 3500000, gasLimit: 3000000))!
            self.client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
                print(txHash!)
                tx = txHash!
                DispatchQueue.main.async {
                    self.txhash.text = "\(tx)"
                }
                
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
