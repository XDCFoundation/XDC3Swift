//
//  ownerOfViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class ownerOfViewController: UIViewController {
    @IBOutlet var txHash: UITextView!
    @IBOutlet var tokenID: UITextField!
    var tokenAddress = ""
    let xrc721 = XRC721Enumerable(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OwnerOfTF(_ sender: Any) {
        let tokenId = BigUInt(tokenID.text!)!
        
        xrc721.ownerOf(contract: XDCAddress(tokenAddress), tokenId: tokenId) { (err, addr) in
            DispatchQueue.main.async {
                self.txHash.text = "\(addr!.value)"
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
