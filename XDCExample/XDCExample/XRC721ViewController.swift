//
//  XRC721ViewController.swift
//  XDCExample
//
//  Created by Developer on 01/07/21.
//

import UIKit
import XDC3Swift
import iOSDropDown
class XRC721ViewController: UIViewController {

    @IBOutlet var drpDown: DropDown!
    @IBOutlet var btn: UIButton!
    @IBOutlet var address: UITextField!
    var valueLabel = ""
    var xinfinAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if address.text == ""{
            self.xinfinAddress = self.valueLabel
            address.text = ""
        }else{
            self.xinfinAddress = address.text!
            address.text = ""
        }
        
        if xinfinAddress.count < 42 && !xinfinAddress.contains("xdc") && !xinfinAddress.contains("0x") {
            self.alert(title: "Alert", msg: "Enter valid address", target: self)
        }else{
        
        let nStroyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let XDC3VC = nStroyBoard.instantiateViewController(identifier: "XRC721DetailViewController") as! XRC721DetailViewController
            XDC3VC.xinfinAddress = self.xinfinAddress
        self.navigationController?.pushViewController(XDC3VC, animated: true)
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
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setup(){
        btn.layer.cornerRadius = 7
        let addr1 = replaceMiddle(of: config.erc721, withCharacter: ".", offset: 12)
        drpDown.optionArray = [addr1]
        drpDown.didSelect { (SelectedText, index, id) in
            if index == 0{
                self.valueLabel = config.erc721
            }
        }
    }
    
}
