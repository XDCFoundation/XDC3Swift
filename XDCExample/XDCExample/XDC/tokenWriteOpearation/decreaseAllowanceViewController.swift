//
//  decreaseAllowanceViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import  XDC3Swift
import  BigInt
class decreaseAllowanceViewController: UIViewController {
    var tokenAddress = ""
    var privateKey = ""
    @IBOutlet var txHash: UITextView!
    @IBOutlet var owner: UITextField!
    @IBOutlet var spenderTextFeild: UITextField!
    @IBOutlet var value: UITextField!
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            let val = BigUInt(self.value.text!)
            self.xdcClient.increaseAllowance(account: try! XDCAccount.init(keyStorage: XDCPrivateKeyStore(privateKey: self.privateKey)), tokenAddress: XDCAddress(self.tokenAddress), owner: XDCAddress(self.owner.text!), spender: XDCAddress(self.spenderTextFeild.text!), value: val!, completion: { (mydata) in
                DispatchQueue.main.async {
                    self.txHash.text = "\(mydata!)"
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
