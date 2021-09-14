//
//  AddNftViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit

class AddNftViewController: UIViewController {
    @IBOutlet var nftAddres: UITextField!
    var tokenAddress = ""
    var accAddr = ""
    var privateK = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddTokenBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let nextVc =  storyboard.instantiateViewController(withIdentifier: "AddedTokenViewController") as! AddedTokenViewController
        nextVc.nftAddrr = self.nftAddres.text!
        nextVc.accAddr = self.accAddr
        nextVc.privateK = self.privateK
        navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func bckBtn(_ sender: UIButton) {
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
