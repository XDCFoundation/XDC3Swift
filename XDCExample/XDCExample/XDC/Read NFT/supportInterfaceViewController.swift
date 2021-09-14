//
//  supportInterfaceViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
class supportInterfaceViewController: UIViewController {
var tokenAddress = ""
    @IBOutlet var txHash: UITextView!
    let xrc721 = XRC721Enumerable(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))

    @IBOutlet var INTERFACEiD: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    @IBAction func supportInterfaceBtn(_ sender: UIButton) {
        let data = INTERFACEiD.text
        xrc721.supportsInterface(contract: XDCAddress(tokenAddress), id: (data?.xdc3.hexData)!) { (err, value) in
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
