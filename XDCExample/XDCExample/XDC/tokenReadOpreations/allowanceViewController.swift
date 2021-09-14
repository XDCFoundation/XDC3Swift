//
//  allowanceViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
class allowanceViewController: UIViewController {

    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    @IBOutlet var allowance: UITextView!
    @IBOutlet var ownerAddress: UITextField!
    @IBOutlet var allowanceTxt: UITextView!
    @IBOutlet var spenderAddress: UITextField!
    var tokenAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send(_ sender: UIButton) {
        xdcClient.allowance(tokenContract: XDCAddress(self.tokenAddress), address: XDCAddress(ownerAddress.text!), spender: XDCAddress(spenderAddress.text!)) { (error, allowanceToken) in
            DispatchQueue.main.async {
                self.allowanceTxt.text = "\(allowanceToken!)"
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
