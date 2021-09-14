//
//  HomeViewController.swift
//  XDCExample
//
//  Created by Developer on 12/08/21.
//

import UIKit
import XDC3Swift
import BigInt
class HomeViewController: UIViewController {

    @IBOutlet var importWallet: UIButton!
    @IBOutlet var createWallet: UIButton!
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
        importWallet.layer.cornerRadius = 7
        createWallet.layer.cornerRadius = 7
        
       
        
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
