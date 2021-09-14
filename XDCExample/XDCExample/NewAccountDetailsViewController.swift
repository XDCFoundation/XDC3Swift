//
//  NewAccountDetailsViewController.swift
//  CXExample
//
//  Created by Prashanth on 17/06/21.
//

import UIKit

class NewAccountDetailsViewController: UIViewController {

    @IBOutlet var privateKey: UITextView!
    @IBOutlet var publicKey: UITextView!
    @IBOutlet var xdcAddress: UITextView!
    var privatek = ""
    var publick = ""
    var addr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // print(123)
        let defaults = UserDefaults.standard
        let values = defaults.array(forKey: "XDCValues")
        if values?.count != 0 {
            xdcAddress.text = values?[0] as? String
            publicKey.text = values?[1] as? String
            privateKey.text = values?[2] as? String
        }
     
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
