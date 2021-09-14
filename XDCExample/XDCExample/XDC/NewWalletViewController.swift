//
//  NewWalletViewController.swift
//  XDCExample
//
//  Created by Developer on 30/08/21.
//

import UIKit

class NewWalletViewController: UIViewController {
    var isActive: Bool?
    @IBOutlet var bar1: UIView!
    @IBOutlet var bar2: UIView!
    
    @IBOutlet var bar1Btn: UIButton!
    @IBOutlet var bar2Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          isActive = true
        // Do any additional setup after loading the view.
    }
    
    func activeCheck(){
        if isActive == true {
            
        }else {
            
        }
    }
    

    @IBAction func bar1Button(_ sender: Any) {
        isActive = true
        activeCheck()
    }
    
    @IBAction func bar2Button(_ sender: Any) {
        isActive = false
        activeCheck()
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
