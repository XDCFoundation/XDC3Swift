//
//  nftViewController.swift
//  XDCExample
//
//  Created by Developer on 17/08/21.
//

import UIKit
import XDC3Swift
class nftViewController: UIViewController {
    var symbol = ""
    @IBOutlet var tokenName: UILabel!
    @IBOutlet var tokenBalanceAndSymbol: UILabel!
    let xdcClient = XRC721Metadata(client: XDCClient(url: URL(string: config.xinfinNetworkUrl)!),metadataSession:  URLSession.shared)
    let client = XDCClient(url: URL(string: config.xinfinNetworkUrl)!)
    var account: XDCAccount?
    var tokenAddress = ""
    var privateKey = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        account = try? XDCAccount(keyStorage: XDCPrivateKeyStore(privateKey: privateKey))
        xdcClient.name(contract: XDCAddress(tokenAddress)) { (err, nameOfToken) in
            DispatchQueue.main.async {
                self.tokenName.text = "\(nameOfToken!)"
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        xdcClient.symbol(contract: XDCAddress(self.tokenAddress)) { (error, symbolOfNFT) in
            DispatchQueue.main.async {
                self.xdcClient.balanceOf(contract: XDCAddress(self.tokenAddress), address: self.account!.address) { (err, balanceOfToken) in
                    DispatchQueue.main.async {
                        self.tokenBalanceAndSymbol.text = "\(symbolOfNFT!) \(balanceOfToken!)"
                    }
                }
            }
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
    @IBAction func readEvents(_ sender: Any) {
        let actionSheet = UIAlertController()

        
        actionSheet.addAction(UIAlertAction(title: "balanceOf", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "balanceOfNFTViewController") as! balanceOfNFTViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "ownerOf", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "ownerOfViewController") as! ownerOfViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "getApproved", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "getApprovedViewController") as! getApprovedViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "isApprovalForAll", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "isApprovalForAllViewController") as! isApprovalForAllViewController
            vc.tokenAddress = self.tokenAddress
           self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "tokenURI", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "tokenURIViewController") as! tokenURIViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "tokenOfOwnerByIndex", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "tokenOfOwnerByIndexViewController") as! tokenOfOwnerByIndexViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "tokenByIndex", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "tokenByIndexViewController") as! tokenByIndexViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "supportInterface", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "supportInterfaceViewController") as! supportInterfaceViewController
            vc.tokenAddress = self.tokenAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func send(_ sender: UIButton) {
        let actionSheet = UIAlertController()

        
        actionSheet.addAction(UIAlertAction(title: "safeTransferFrom", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "safeTransferFromViewController") as! safeTransferFromViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "approve", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "approveNftViewController") as! approveNftViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "setApprovalForAll", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "setApprovalForAllViewController") as! setApprovalForAllViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "transferFrom", style: .default, handler: { (action) in
            let uiStory = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = uiStory.instantiateViewController(withIdentifier: "transferFromNftViewController") as! transferFromNftViewController
            vc.tokenAddress = self.tokenAddress
            vc.privateKey = self.privateKey
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func bckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
