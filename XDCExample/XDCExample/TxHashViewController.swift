//
//  TxHashViewController.swift
//  CXExample
//
//  Created by Developer on 23/06/21.
//

import UIKit

class TxHashViewController: UIViewController {

    @IBOutlet var txHash: UITextView!
    var tx = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(tx)
        txHash.text = tx
        // Do any additional setup after loading the view.
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
        self.navigationController?.popViewController(animated: true)
    }
    
}
