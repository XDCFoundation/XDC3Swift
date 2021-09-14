//
//  balanceOfViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
class balanceOfViewController: UIViewController {
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    @IBOutlet var balanceOf: UITextField!
    @IBOutlet var balance: UITextView!
    @IBOutlet var checkBtn: UIButton!
    var tokenAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    setupHideKeyboardOnTap()
        print(tokenAddress)
        checkBtn.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        xdcClient.balanceOf(tokenContract: XDCAddress(self.tokenAddress), account: XDCAddress(balanceOf.text!)) { (err, bal) in
            DispatchQueue.main.async {
                self.balance.text = "\(bal!)"
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
