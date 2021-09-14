//
//  getApprovedViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class getApprovedViewController: UIViewController {
    @IBOutlet var tokenId: UITextField!
    @IBOutlet var txHash: UITextView!
    let xrc721 = XRC721(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    var tokenAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getApprovedBTn(_ sender: UIButton) {
        let token = BigUInt(tokenId.text!)!
        xrc721.getApproved(contract: XDCAddress(tokenAddress), tokenId: token) { (err, addr) in
            DispatchQueue.main.async {
                self.txHash.text = "\(addr!.value)"
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
