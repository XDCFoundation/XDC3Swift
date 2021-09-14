//
//  totalSuuplyViewController.swift
//  XDCExample
//
//  Created by Developer on 18/08/21.
//

import UIKit
import XDC3Swift
class totalSuuplyViewController: UIViewController {
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    var tokenAddress = ""
    @IBOutlet var totalSupply: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        xdcClient.totalSupply(contract: XDCAddress(self.tokenAddress)) { (error, totalSupplyOfToken) in
            DispatchQueue.main.async {
                self.totalSupply.text = "\(totalSupplyOfToken!)"
            }
        }
        // Do any additional setup after loading the view.
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
