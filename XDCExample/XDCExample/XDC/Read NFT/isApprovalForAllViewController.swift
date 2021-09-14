//
//  isApprovalForAllViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
class isApprovalForAllViewController: UIViewController {
    @IBOutlet var ownerAddr: UITextField!
    @IBOutlet var txHash: UITextView!
    @IBOutlet var opearatorAddr: UITextField!
    var tokenAddress = ""
    let xrc721 = XRC721(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func isApprovedForAll(_ sender: UIButton) {
        xrc721.isApprovedForAll(contract: XDCAddress(tokenAddress), opearator: XDCAddress(opearatorAddr.text!), owner: XDCAddress(ownerAddr.text!)) { (error, value) in
            DispatchQueue.main.async {
                self.txHash.text = "\(value!)"
            }
        }
    }
    @IBAction func bckBtn(_ sender: Any) {
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
