//
//  CreateAccountViewController.swift
//  CXExample
//
//  Created by Prashanth on 16/06/21.
//

import UIKit
import XDC3Swift

class CreateAccountViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var passwordTF: UITextField!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        passwordTF.isSecureTextEntry = true
      //  let sign = try! XinfinAccount.sign(xin)
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
     } 
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValidPassword(testPwd : String?) -> Bool{
            guard testPwd != nil else {
                return false
            }
            let passwordPred = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$")
            return passwordPred.evaluate(with: testPwd)
        }
    @IBAction func createBtnAct(_ sender: Any) {
       if self.passwordTF.text != "" && isValidPassword(testPwd: self.passwordTF.text) == true{
            let XinFinAcc = try! XDCAccount.create(keyStorage:XDCKeyLocalStorage(), keystorePassword:passwordTF.text ?? "")
       /*
           print("Address: \(XinFinAcc.address)")
            print("Public Key: \(XinFinAcc.publicKey)")
            print("Private Key \(XinFinAcc.privateKey)")
        */
        let xinfinAdd = "\(XinFinAcc.address)"
        
      let add = xinfinAdd.replacingOccurrences(of: "XinfinAddress(value: ", with: "")
        let remove = add.replacingOccurrences(of: ")", with: " ")
    
            if "\(XinFinAcc.address)" != "" && "\(XinFinAcc.publicKey)"  != "" {

                self.showAlertWithSuccess(withTitle: "Alert", andMessage: "Account Created Succesfully") { (success) in
                    if success {
                        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let details = main.instantiateViewController(withIdentifier: "NewAccountDetailsViewController") as! NewAccountDetailsViewController
                       let addr = "\(XinFinAcc.address.value)"
                        let privatek = "\(XinFinAcc.privateKey)"
                        let publick =  "\(XinFinAcc.publicKey)"
                        
                        let XDCValues = [addr, publick, privatek]
                        self.defaults.set(XDCValues, forKey: "XDCValues")
                        
                        self.navigationController?.pushViewController(details, animated: true)
                    }
                }
             //  alertWithTF(Address:"\(remove)", key:"\(XinFinAcc.publicKey)")

            }
            
       }else{
        self.alert(title: "Alert", msg: "Password should contain minimum of 8 character", target: self)
       }
        
     
    }
    

}

