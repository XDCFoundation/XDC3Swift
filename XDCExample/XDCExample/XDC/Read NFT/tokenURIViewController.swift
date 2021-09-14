//
//  tokenURIViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class tokenURIViewController: UIViewController {
    @IBOutlet var tokenId: UITextField!
    @IBOutlet var txHash: UITextView!
    var tokenAddress = ""
    let xrc721Metadata = XRC721Metadata(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!), metadataSession: URLSession.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    @IBAction func tokenURIBtn(_ sender: UIButton) {
        let index = BigUInt(tokenId.text!)
        xrc721Metadata.tokenURI(contract: XDCAddress(tokenAddress), tokenID: index!) { (err, url) in
            DispatchQueue.main.async {
                self.txHash.text = "\(url!)"
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
