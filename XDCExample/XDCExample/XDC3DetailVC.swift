//
//  XDC3DetailVC.swift
//  CXExample
//
//  Created by Developer on 15/06/21.
//

import UIKit
import XDC3Swift
import BigInt



class XDC3DetailVC: UIViewController {

    @IBOutlet var XDC_Address: UILabel!
    
    // Read methods
    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Symbol: UILabel!
    @IBOutlet var Decimal: UILabel!
    @IBOutlet var Balance: UILabel!
    @IBOutlet var TotalSupply: UILabel!
    
    // Write methods
    
    @IBOutlet var Approve: UITextView!
   // @IBOutlet var Approve: UILabel!
    @IBOutlet var Allowance: UILabel!
  //  @IBOutlet var Transfer: UILabel!
    @IBOutlet var Transfer: UITextView!
   // @IBOutlet var TransferFrom: UILabel!
    @IBOutlet var TransferFrom: UITextView!
    //  @IBOutlet var IncreaseAllowance: UILabel!
    @IBOutlet var IncreaseAllowance: UITextView!
   // @IBOutlet var DecreaseAllowance: UILabel!
    @IBOutlet var DecreaseAllowance: UITextView!
    @IBOutlet var senderAddress: UILabel!
    
    
    // TextFeilds
    
    @IBOutlet var balanceOfAddressTf: UITextField!
    @IBOutlet var AllowanceOwnerTf: UITextField!
    @IBOutlet var SpenderAllowanceTf: UITextField!
    @IBOutlet var ApproveSpender: UITextField!
    @IBOutlet var ApproveValueTf: UITextField!
    @IBOutlet var TransferToTf: UITextField!
    @IBOutlet var TransferValueTf: UITextField!
    @IBOutlet var IAownerTf: UITextField!
    @IBOutlet var IASpenderTf: UITextField!
    @IBOutlet var IAValueTf: UITextField!
    @IBOutlet var DAOwnerTf: UITextField!
    @IBOutlet var DASpenderTf: UITextField!
    @IBOutlet var DAValueTf: UITextField!
    @IBOutlet var TFSpenderTf: UITextField!
    @IBOutlet var TFToTf: UITextField!
    @IBOutlet var TFValueTf: UITextField!
    @IBOutlet var privateKeyTf: UITextField!
    
    
    // Buttons
    @IBOutlet var checkPrivateKey: UIButton!
    @IBOutlet var balanceOfBtn: UIButton!
    @IBOutlet var AllowanceBtn: UIButton!
    @IBOutlet var ApproveBtn: UIButton!
    @IBOutlet var transferBtn: UIButton!
    @IBOutlet var IABtn: UIButton!
    @IBOutlet var DABtn: UIButton!
    @IBOutlet var TransferFromBtn: UIButton!
    
    
    var xinfinAddress = ""
    var account: XDCAccount?
    var XRC: XRC20?
    
    //  Creating an instance of XRC20
    
    let xinfinClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    
    //  Creating an instance of XinfinClient. This will then provide access to a set of functions for interacting with the Blockchain.
    
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        readMethods()
//        let account = try! XinfinAccount.init(keyStorage: XinfinPrivateKeyStore(privateKey: "0x2b6dbb667da5962bb96fe9ae87c53a5308afeabb6f6be0be2d5f27be2efcf4cd"))
//        print(account.address)
        self.setupHideKeyboardOnTap()
    }
    
    func readMethods(){
    let dotted = replaceMiddle(of: xinfinAddress, withCharacter: ".", offset: 12)

        
        XDC_Address.text = dotted
        
        // used to fetch token name
        xinfinClient.name(tokenContract: XDCAddress(xinfinAddress)) { (err, name) in
            DispatchQueue.main.async {
                self.Name.text = "Name : \(name ?? "_")"
              //  print("Name : \(name!)")
            }
        }
        
        // used to fetch token decimal
        xinfinClient.decimals(tokenContract: XDCAddress(xinfinAddress)) { (err, decimal) in
            DispatchQueue.main.async {
                self.Decimal.text = "Decimal : \(decimal!)"
              //  print("Decimal : \(decimal!)")
            }
        }
        
        // used to fetch token symbol
        xinfinClient.symbol(tokenContract: XDCAddress(xinfinAddress)) { (err, symbol) in
            DispatchQueue.main.async {
                self.Symbol.text = "Symbol : \(symbol!)"
              //  print("Symbol : \(symbol!)")
            }
        }
        
        // used to fetch token totalSupply
        xinfinClient.totalSupply(contract: XDCAddress(xinfinAddress)) { (err, totalSupply) in
            DispatchQueue.main.async {
                self.TotalSupply.text = "Total supply : \(totalSupply!/1000000000000000000)"
               // print("Total supply:- \(totalSupply!/1000000000000000000)")
            }
        }
        
    }

    @IBAction func btnBack(_ sender: Any) {
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
  
    @IBAction func chkPrivateKey(_ sender: UIButton) {
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKeyTf.text!))
        self.senderAddress.text = "\(account!.address.value)"
    }
    
    @IBAction func balanceOff(_ sender: UIButton) {
      //  print(xinfinAddress)
        DispatchQueue.main.async {
            self.xinfinClient.balanceOf(tokenContract: XDCAddress(self.xinfinAddress), account: XDCAddress(self.balanceOfAddressTf.text!)) { (error, balance) in
            DispatchQueue.main.async {
           //     print(balance!)
                self.Balance.text = "balanceOff : \(balance!)"
            }
        }
        }
    }
    
    @IBAction func AllowanceSubmit(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.xinfinClient.allowance(tokenContract: XDCAddress(self.xinfinAddress), address: XDCAddress(self.AllowanceOwnerTf.text!), spender: XDCAddress(self.SpenderAllowanceTf.text!)) { (error, allowance) in
            
                DispatchQueue.main.async {
                    self.Allowance.text = "Allowance : \(allowance!)"
                }
            }
        }
    }
    @IBAction func Approve(_ sender: UIButton) {
        let val = BigUInt(self.ApproveValueTf.text!)
        var tx = ""
        DispatchQueue.main.async {
            let function = XRC20Functions.approve(contract: XDCAddress(self.xinfinAddress), spender: XDCAddress(self.ApproveSpender.text!), value: val!)
        let transaction = (try? function.transaction(gasPrice: 3500000, gasLimit: 3000000))!
            self.client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
          //  print("TX Hash: \(txHash ?? "")")
                tx = txHash!
                DispatchQueue.main.async {
                    self.Approve.text = "Approve : \(tx)"
                }
               
        }
        }
        
    }
    @IBAction func Transfer(_ sender: UIButton) {
        let val = BigUInt(self.TransferValueTf.text!)!
    
        var tx = ""
        DispatchQueue.main.async {
            let function = XRC20Functions.transfer(contract: XDCAddress(self.xinfinAddress), to: XDCAddress(self.TransferToTf.text!), value: val * 1000000000000000000)
        let transaction = (try? function.transaction(gasPrice: 350000, gasLimit: 300000))!
            self.client.eth_sendRawTransaction(transaction, withAccount: self.account!) { (error, txHash) in
         //   print("TX Hash: \(txHash ?? "")")
                tx = txHash!
                DispatchQueue.main.async {
                    self.Transfer.text = "Transfer : \(tx)"
                }
               
        }
        }
      
    }
    
    @IBAction func increaseAllowance(_ sender: Any) {
        
       
        DispatchQueue.main.async {
            let val = BigUInt(self.IAValueTf.text!)
            self.xinfinClient.increaseAllowance(account: try! XDCAccount.init(keyStorage: XDCPrivateKeyStore(privateKey: self.privateKeyTf.text!)), tokenAddress: XDCAddress(self.xinfinAddress), owner: XDCAddress(self.IAownerTf.text!), spender: XDCAddress(self.IASpenderTf.text!), value: val!, completion: { (mydata) in
          //  print(mydata!)
                DispatchQueue.main.async {
                    self.IncreaseAllowance.text = "Increase Allowance : \(mydata!)"
                }
                
        })
        }
        
    }
    @IBAction func decreaseAllowance(_ sender: Any) {
        
        let val = BigUInt(self.DAValueTf.text!)
        DispatchQueue.main.async {
            self.xinfinClient.decreaseAllowance(account: try! XDCAccount.init(keyStorage: XDCPrivateKeyStore(privateKey: self.privateKeyTf.text!)), tokenAddress: XDCAddress(self.xinfinAddress), owner: XDCAddress(self.DAOwnerTf.text!), spender: XDCAddress(self.DASpenderTf.text!), value: val!, completion: { (mydata) in
         //   print(mydata!)
                DispatchQueue.main.async {
                    self.DecreaseAllowance.text = "Decrease Allowance : \(mydata!)"
                }
                
                
        })
        }
       
    }
    @IBAction func TransferFrom(_ sender: Any) {
        
        DispatchQueue.main.async {
            let val = BigUInt(self.TFValueTf.text!)
            let function = XRC20Functions.transferFrom(contract: XDCAddress(self.xinfinAddress), sender: XDCAddress(self.TFSpenderTf.text!), to: XDCAddress(self.TFToTf.text!), value: val!)
            let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
            
            self.client.eth_sendRawTransaction(transaction!, withAccount: self.account!, completion: { (error, txhash) in
                DispatchQueue.main.async {
                  //  print(txhash!)
                    self.TransferFrom.text = "TransferFrom : \(txhash!)"
                }
               
                
            })
        }
        
    }
    
    
    
}

extension UIViewController {
    func replaceMiddle(of text: String, withCharacter character: String, offset: Int) -> String {
        let i1: String.Index = text.index(text.startIndex, offsetBy: offset)
        let i2: String.Index = text.index(text.endIndex, offsetBy: -1 * offset)
        let replacement = String(repeating: character, count: text.count - 3 * offset)
        return text.replacingCharacters(in: i1..<i2, with: replacement)
    }
    
    func alertWithTF(Address:String , key:String) {
        
        let alert = UIAlertController(title: "Successfully Created", message: "Note this Address and public key for future referece", preferredStyle: .alert)
        // Login button

        
        let loginAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            // Get TextFields text
        })
        
        //1 textField for username
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "XDC Address"
            //If required mention keyboard type, delegates, text sixe and font etc...
            //EX:
            textField.keyboardType = .default
        }
        
        //2nd textField for password
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "XDC Public Key"
        }
        alert.textFields?[0].text = "\(Address)"
        alert.textFields?[1].text = "\(key)"
        
        // Add actions
        alert.addAction(loginAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
        func alert(title:String, msg:String, target: UIViewController) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            (result: UIAlertAction) -> Void in
             
            })
    
            target.present(alert, animated: true, completion: nil)
        }
    func showAlertWithSuccess(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            completion(true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
