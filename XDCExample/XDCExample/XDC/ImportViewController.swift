//
//  ImportViewController.swift
//  XDCExample
//
//  Created by Developer on 12/08/21.
//

import UIKit
import  XDC3Swift
class ImportViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var passwordTf: UITextField!
    @IBOutlet var confirmPasswordTf: UITextField!
    var mnemonic: String! = nil
    @IBOutlet var recoveryPhrase: UITextView!
    @IBOutlet var importWalletBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordTf.delegate = self
        passwordTf.delegate = self
//        passwordTf.isSecureTextEntry = true
//        confirmPasswordTf.isSecureTextEntry = true
//      passwordTf.autocorrectionType = .no
//      confirmPasswordTf.autocorrectionType = .no
        recoveryPhrase.layer.borderWidth = 1
        recoveryPhrase.layer.borderColor = UIColor(hexString: "#E5E9EB").cgColor
        recoveryPhrase.layer.cornerRadius = 7
        importWalletBtn.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
       
        setupHideKeyboardOnTap()
      
      
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == self.passwordTf) { self.passwordTf.isSecureTextEntry = true }
        if(textField == self.confirmPasswordTf) { self.confirmPasswordTf.isSecureTextEntry = true }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func importWalletBtn(_ sender: UIButton) {
        if passwordTf.text == confirmPasswordTf.text{
        mnemonic = recoveryPhrase.text
        let importFromMnemonic = try! XDCAccount.importAccountWithMnemonic(mnemonic: mnemonic)
        let UIstoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = UIstoryboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        nextVC.accAddr = importFromMnemonic.address
        nextVC.privateK = importFromMnemonic.rawPrivateKey
        navigationController?.pushViewController(nextVC, animated: true)
    }
    else{
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
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
