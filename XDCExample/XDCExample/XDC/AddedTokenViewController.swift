//
//  AddedTokenViewController.swift
//  XDCExample
//
//  Created by Developer on 13/08/21.
//

import UIKit
import XDC3Swift
class AddedTokenViewController: UIViewController {
    var tokenAddrr = ""
    var tokenSym = ""
    var tokenDeci = ""
    var accAddr = ""
    var privateK = ""
    var XRC: XRC20?
    var Symbol:String!
    var balanceOf = ""
    var nftAddrr = ""
    var nftSymbol = ""
    //  Creating an instance of XRC20
    @IBOutlet var logOut: UIButton!
    let nft = XRC721Metadata(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!), metadataSession: URLSession.shared)
    let xdcClient = XRC20.init(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!))
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    @IBOutlet var accountBalnce: UILabel!
    @IBOutlet var accountAddress: UILabel!
    @IBOutlet var tokenInfo: UILabel!
    @IBOutlet var tokenInfoBtn: UIButton!
    @IBOutlet var backButtonOutlet: UIButton!
    @IBOutlet var nftInfo: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var addTokenOutlet: UIButton!
    @IBOutlet var addNFTOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        sendButton.layer.cornerRadius = 7
        addTokenOutlet.layer.cornerRadius = 7
        addNFTOutlet.layer.cornerRadius = 7
        addTokenOutlet.layer.borderColor = UIColor(hexString: "#2148B8").cgColor
        addNFTOutlet.layer.borderColor = UIColor(hexString: "#2148B8").cgColor
        addTokenOutlet.layer.borderWidth = 1
        addNFTOutlet.layer.borderWidth = 1
        backButtonOutlet.isHidden = true
        logOut.tintColor = .white
        let dotted = replaceMiddle(of: accAddr, withCharacter: ".", offset: 12)
        accountAddress.text = dotted
        self.client.eth_getBalance(address: XDCAddress(self.accAddr), block: .Latest) { (error, balanceOf) in
            DispatchQueue.main.async {
                let value = balanceOf!/1000000000000000000
                self.accountBalnce.text = "\(value) XDC"
            }
        }
        if tokenAddrr != "" {
            xdcClient.symbol(tokenContract: XDCAddress(tokenAddrr)) { (err, symbol) in
                DispatchQueue.main.async {
                    self.Symbol = symbol
                    self.xdcClient.balanceOf(tokenContract: XDCAddress(self.tokenAddrr), account: XDCAddress(self.accAddr)) { (err, balance) in
                        DispatchQueue.main.async {
                            self.balanceOf = "\(balance!)"
                            self.tokenInfo.text = "\(self.Symbol!) \(self.balanceOf)"
                        }
                    }
                }
            }
        }
        if nftAddrr != "" {
            nft.symbol(contract: XDCAddress(nftAddrr)) { (err, nameOfNFT) in
                DispatchQueue.main.async {
                    self.nftSymbol = nameOfNFT!
                    self.nft.balanceOf(contract: XDCAddress(self.nftAddrr), address: XDCAddress(self.accAddr)) { (err, balanceOfNFT) in
                        DispatchQueue.main.async {
                            self.nftInfo.text = "\(self.nftSymbol) \(balanceOfNFT!)"
                        }
                    }
                }
            }
        }
        //   print("\(Symbol) \(balanceOf)")
        //        tokenInfo.text = "\(Symbol!) \(balanceOf)"
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.client.eth_getBalance(address: XDCAddress(self.accAddr), block: .Latest) { (error, balanceOf) in
            DispatchQueue.main.async {
                let value = balanceOf!/1000000000000000000
                self.accountBalnce.text = "\(value) XDC"
            }
        }
        if tokenAddrr != "" {
            xdcClient.symbol(tokenContract: XDCAddress(tokenAddrr)) { (err, symbol) in
                DispatchQueue.main.async {
                    self.Symbol = symbol
                    self.xdcClient.balanceOf(tokenContract: XDCAddress(self.tokenAddrr), account: XDCAddress(self.accAddr)) { (err, balance) in
                        DispatchQueue.main.async {
                            self.balanceOf = "\(balance!)"
                            self.tokenInfo.text = "\(self.Symbol!) \(self.balanceOf)"
                        }
                    }
                }
            }
        }
        if nftAddrr != "" {
            nft.symbol(contract: XDCAddress(nftAddrr)) { (err, nameOfNFT) in
                DispatchQueue.main.async {
                    self.nftSymbol = nameOfNFT!
                    self.nft.balanceOf(contract: XDCAddress(self.nftAddrr), address: XDCAddress(self.accAddr)) { (err, balanceOfNFT) in
                        DispatchQueue.main.async {
                            self.nftInfo.text = "\(self.nftSymbol) \(balanceOfNFT!)"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func copyButton(_ sender: UIButton) {
        UIPasteboard.general.string = accAddr
    }
    @IBAction func transferXDC(_ sender: Any) {
        let uistory = UIStoryboard.init(name: "Maiin", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        vc.privateKey = self.privateK
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logout(_ sender: Any) {
        let uistory = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tokenInfoButton(_ sender: UIButton) {
        let uistory = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "tokenViewController") as! tokenViewController
        vc.privateKey = self.privateK
        vc.tokenAddress = self.tokenAddrr
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func AddTokenBtn(_ sender: Any) {
        let uistoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let nextVC = uistoryboard.instantiateViewController(withIdentifier: "AddingTokenViewController") as! AddingTokenViewController
        nextVC.accAddr = self.accAddr
        nextVC.privateK = self.privateK
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction func AddNft(_ sender: Any) {
        let uistoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let nextVC = uistoryboard.instantiateViewController(withIdentifier: "AddNftViewController") as! AddNftViewController
        nextVC.accAddr = self.accAddr
        nextVC.privateK = self.privateK
        navigationController?.pushViewController(nextVC, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func bckBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nftInfo(_ sender: UIButton) {
        let uistory = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = uistory.instantiateViewController(withIdentifier: "nftViewController") as! nftViewController
        vc.privateKey = self.privateK
        vc.tokenAddress = self.nftAddrr
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
