//
//  WalletViewController.swift
//  XDCExample
//
//  Created by Developer on 12/08/21.
//

import UIKit
import XDC3Swift
// print trust learn ice prize only boost label any sibling trumpet sail
// 0x7204a7c2333124a6c5606e0830cca58354322bb7
class WalletViewController: UIViewController {
    @IBOutlet var addToken: UIButton!
    var accAddr = ""
    var privateK = ""
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    @IBOutlet var BackButtonOutlet: UIButton!
    @IBOutlet var accountAddress: UILabel!
    @IBOutlet var balance: UILabel!
    @IBOutlet var send: UIButton!

    @IBOutlet var addNFTOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addToken.layer.cornerRadius = 7
        addToken.layer.borderColor = UIColor(hexString: "#2148B8").cgColor
        addToken.layer.borderWidth = 1
        addNFTOutlet.layer.cornerRadius = 7
        addNFTOutlet.layer.borderColor = UIColor(hexString: "#2148B8").cgColor
        send.layer.cornerRadius = 7
        addNFTOutlet.layer.borderWidth = 1
        let dotted = replaceMiddle(of: accAddr, withCharacter: ".", offset: 12)
        accountAddress.text = dotted
            self.client.eth_getBalance(address: XDCAddress(self.accAddr), block: .Latest) { (error, balanceOf) in
                DispatchQueue.main.async {
                    let value = balanceOf!/1000000000000000000
                    self.balance.text = "\(value) XDC"
                }
            }
        
        // Do any additional setup after loading the view.
        setupHideKeyboardOnTap()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.BackButtonOutlet.isHidden = true
            self.client.eth_getBalance(address: XDCAddress(self.accAddr), block: .Latest) { (error, balanceOf) in
                DispatchQueue.main.async {
                    let value = balanceOf!/1000000000000000000
                    self.balance.text = "\(value) XDC"
                }
            }
    }
    @IBAction func copyButton(_ sender: UIButton) {
        UIPasteboard.general.string = accAddr
    }
    @IBAction func logout(_ sender: Any) {
        let uistory = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func transferXDC(_ sender: Any) {
        let uistory = UIStoryboard.init(name: "Maiin", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        vc.privateKey = self.privateK
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
    }
    @IBAction func addTokenBtn(_ sender: UIButton) {
        let uistoryboard = UIStoryboard.init(name: "Main", bundle: nil)
       
        let nextVC = uistoryboard.instantiateViewController(withIdentifier: "AddingTokenViewController") as! AddingTokenViewController
        nextVC.accAddr = self.accAddr
        nextVC.privateK = self.privateK
        navigationController?.pushViewController(nextVC, animated: true)
    }
    /*s
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func AddNFT(_ sender: Any) {
        let uistoryboard = UIStoryboard.init(name: "Main", bundle: nil)
       
        let nextVC = uistoryboard.instantiateViewController(withIdentifier: "AddNftViewController") as! AddNftViewController
        nextVC.accAddr = self.accAddr
        nextVC.privateK = self.privateK
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
