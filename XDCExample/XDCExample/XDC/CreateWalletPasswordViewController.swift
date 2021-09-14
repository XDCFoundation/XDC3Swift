//
//  CreateWalletPasswordViewController.swift
//  XDCExample
//
//  Created by Developer on 13/08/21.
//

import UIKit
import XDC3Swift
class CreateWalletPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
        password.delegate = self
        confirmPassword.delegate = self
//        password.isSecureTextEntry = true
//        confirmPassword.isSecureTextEntry = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == self.password) { self.password.isSecureTextEntry = true }
        if(textField == self.confirmPassword) { self.confirmPassword.isSecureTextEntry = true }
    }
    @IBAction func bckBtb(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createWallet(_ sender: Any) {
        if password.text == confirmPassword.text{
        let acc = try! XDCAccount.createAccountWithMemonic()
        let alert = UIAlertController(title: "seed phrase", message: "\(acc)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: { (action) in
            let importFromMnemonic = try! XDCAccount.importAccountWithMnemonic(mnemonic: acc)
            let UIstoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = UIstoryboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextVC.accAddr = importFromMnemonic.address
            nextVC.privateK = importFromMnemonic.rawPrivateKey
            print(importFromMnemonic.address)
            print(importFromMnemonic.rawPrivateKey)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        }else{
            self.alert(title: "Alert", msg: "password and confirm password should be same", target: self)
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

}
