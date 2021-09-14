//
//  tokenViewController.swift
//  XDCExample
//
//  Created by Developer on 16/08/21.
//

import UIKit
import XDC3Swift
class tokenViewController: UIViewController {
    @IBOutlet var sendBtnOutlet: UIButton!
    @IBOutlet var tokenName: UILabel!
    @IBOutlet var tokenBalance: UILabel!
    var symbol = ""
    var balanceOf = ""
    var account: XDCAccount?
    var tokenAddress = ""
    var privateKey = ""
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        sendBtnOutlet.layer.cornerRadius = 7
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        xdcClient.name(tokenContract: XDCAddress(tokenAddress)) { (error, token) in
            DispatchQueue.main.async {
                self.tokenName.text = "\(token!)"
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        xdcClient.symbol(tokenContract: XDCAddress(tokenAddress)) { (err, symbol) in
            DispatchQueue.main.async {
                self.symbol = symbol!
                self.xdcClient.balanceOf(tokenContract: XDCAddress(self.tokenAddress), account: self.account!.address) { (err, balance) in
                    DispatchQueue.main.async {
                        self.balanceOf = "\(balance!)"
                        self.tokenBalance.text = "\(self.balanceOf) \(self.symbol)"
                    }
                }
            }
        }
        
    }
    @IBAction func show() {
        let actionSheet = UIAlertController()
        
        let attributedString = NSAttributedString(string: "Write methods for token", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)
        ])
        
       // actionSheet.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        actionSheet.setValue(attributedString, forKey: "attributedTitle")
        let action1 = UIAlertAction(title: "transfer", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "tokenTransferViewController") as! tokenTransferViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action2 = UIAlertAction(title: "approve", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "approveViewController") as! approveViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action3 = UIAlertAction(title: "increasAllowance", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "decreaseAllowanceViewController") as! decreaseAllowanceViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action4 = UIAlertAction(title: "decreaseAllowance", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "increaseAllowanceViewController") as! increaseAllowanceViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action5 = UIAlertAction(title: "transferFrom", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "transferFromViewController") as! transferFromViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        action1.setValue(UIColor.black, forKey: "titleTextColor")
        action2.setValue(UIColor.black, forKey: "titleTextColor")
        action3.setValue(UIColor.black, forKey: "titleTextColor")
        action4.setValue(UIColor.black, forKey: "titleTextColor")
        action5.setValue(UIColor.black, forKey: "titleTextColor")
        
        action1.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action3.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action4.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action5.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(action5)
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
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
    @IBAction func readShow(_ sender: UIButton) {
        let actionSheet = UIAlertController()
        
        let attributedString = NSAttributedString(string: "Read methods for token", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)
        ])
       actionSheet.setValue(attributedString, forKey: "attributedTitle")
        let action1 =  UIAlertAction(title: "name", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "nameViewController") as! nameViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action2 = UIAlertAction(title: "totalSupply", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "totalSuuplyViewController") as! totalSuuplyViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action3 = UIAlertAction(title: "decimal", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "decimalViewController") as! decimalViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action4 = UIAlertAction(title: "balanceOf", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "balanceOfViewController") as! balanceOfViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action5 = UIAlertAction(title: "allowance", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "allowanceViewController") as! allowanceViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        })
        action1.setValue(UIColor.black, forKey: "titleTextColor")
        action2.setValue(UIColor.black, forKey: "titleTextColor")
        action3.setValue(UIColor.black, forKey: "titleTextColor")
        action4.setValue(UIColor.black, forKey: "titleTextColor")
        action5.setValue(UIColor.black, forKey: "titleTextColor")
        
        action1.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action3.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action4.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action5.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(action5)
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
}
