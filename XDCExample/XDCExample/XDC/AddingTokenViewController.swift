//
//  AddingTokenViewController.swift
//  XDCExample
//
//  Created by Developer on 13/08/21.
//

import UIKit

class AddingTokenViewController: UIViewController {
    var tokenAddrr = ""
    var tokenSym = ""
    var tokenDeci = ""
    var accAddr = ""
    var privateK = ""
    @IBOutlet var tokenAddress: UITextField!
    @IBOutlet var tokenSymbol: UITextField!
    @IBOutlet var tokenDecimal: UITextField!
    @IBOutlet var addToken: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        addToken.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddTokenBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let nextVc =  storyboard.instantiateViewController(withIdentifier: "AddedTokenViewController") as! AddedTokenViewController
        nextVc.tokenAddrr = tokenAddress.text!
        nextVc.tokenSym = tokenSymbol.text!
        nextVc.tokenDeci = tokenDecimal.text!
        nextVc.accAddr = self.accAddr
        nextVc.privateK = self.privateK
        navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func bckBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
