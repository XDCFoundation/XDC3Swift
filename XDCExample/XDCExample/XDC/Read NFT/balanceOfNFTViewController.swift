//
//  balanceOfNFTViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import  XDC3Swift

class balanceOfNFTViewController: UIViewController {
var tokenAddress = ""
    @IBOutlet var address: UITextField!
    @IBOutlet var txHash: UITextView!
    let xrc721 = XRC721Enumerable(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func balanceOfBtn(_ sender: UIButton) {
        xrc721.balanceOf(contract: XDCAddress(tokenAddress), address: XDCAddress(address.text!)) { (err, balanceOf) in
            DispatchQueue.main.async {
                self.txHash.text = "\(balanceOf!)"
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
