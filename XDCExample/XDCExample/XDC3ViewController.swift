//
//  XDC3ViewController.swift
//  CXExample
//
//  Created by Developer on 15/06/21.
//

import UIKit
import iOSDropDown
import XDC3Swift
class XDC3ViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileIcon: UIButton!
    @IBOutlet var SubmitBtn: UIButton!
    @IBOutlet var SelectFromList: DropDown!
    @IBOutlet var EnterXDCAddress: UITextField!
    var xinfinAddress = ""
    var valueLabel = ""
    var textId = 0

        
    //  Creating an instance of XRC20
    
    let xinfinClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    
    //  Creating an instance of XinfinClient. This will then provide access to a set of functions for interacting with the Blockchain.
    
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        let values = defaults.array(forKey: "XDCValues")
        if values?.count != nil {
         //   EnterXDCAddress.text = values?[0] as? String
            profileIcon.isHidden = false
            profileImg.isHidden = false
        }else{
            profileIcon.isHidden = true
            profileImg.isHidden = true

        }
        self.setupHideKeyboardOnTap()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func profileView(_ sender: Any) {
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let details = main.instantiateViewController(withIdentifier: "NewAccountDetailsViewController") as! NewAccountDetailsViewController
        self.navigationController?.pushViewController(details, animated: true)

    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createAccount(_ sender: Any) {
        
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        if EnterXDCAddress.text == ""{
            self.xinfinAddress = self.valueLabel
            SelectFromList.text = ""
        }else{
            self.xinfinAddress = EnterXDCAddress.text!
            EnterXDCAddress.text = ""
        }
        
        if !xinfinAddress.contains("xdc") && !xinfinAddress.contains("0x") {
            self.alert(title: "Alert", msg: "Enter valid address", target: self)
        }else{
        
        let nStroyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let XDC3VC = nStroyBoard.instantiateViewController(identifier: "XDC3DetailVC") as! XDC3DetailVC
        XDC3VC.xinfinAddress = self.xinfinAddress
        self.navigationController?.pushViewController(XDC3VC, animated: true)
        }
        
    }
    
    func setup(){
        SubmitBtn.layer.cornerRadius = 7
        let addr1 = replaceMiddle(of: config.init().address1, withCharacter: ".", offset: 12)
        let addr2 = replaceMiddle(of: config.init().address2, withCharacter: ".", offset: 12)
        let addr3 = replaceMiddle(of: config.init().address3, withCharacter: ".", offset: 12)
        SelectFromList.optionArray = [addr1,addr2,addr3]
        SelectFromList.didSelect { (SelectedText, index, id) in
            if index == 0{
                self.valueLabel = config.init().address1
            }else if index  == 1{
                self.valueLabel = config.init().address2
            }else if index == 2{
                self.valueLabel = config.init().address3
            }
          
         //   print(self.valueLabel)
        }
    }


}
