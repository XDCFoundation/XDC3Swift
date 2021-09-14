//
//  ViewController.swift
//  XDCExample
//
//  Created by Developer on 24/06/21.
//

import UIKit
import XDC3Swift
class ViewController: UIViewController {
    @IBOutlet var XRC721Btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let x = WelcomeXDC()
        x.welcome()
        
    }


}

