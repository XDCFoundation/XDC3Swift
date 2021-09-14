//
//  tokenOfOwnerByIndexViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class tokenOfOwnerByIndexViewController: UIViewController {
    @IBOutlet var txHash: UITextView!
    @IBOutlet var ownerAddress: UITextField!
    @IBOutlet var index: UITextField!
    let xrc721 = XRC721Enumerable(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    var tokenAddress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    @IBAction func tokenOfOwnerByIndexBtn(_ sender: UIButton) {
        let indx = BigUInt(index.text!)
        xrc721.tokenOfOwnerByIndex(contract: XDCAddress(tokenAddress), owner: XDCAddress(ownerAddress.text!), index: indx!) { (err, token) in
            DispatchQueue.main.async {
                self.txHash.text = "\(token!)"
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
