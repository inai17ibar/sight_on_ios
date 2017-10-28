//
//  HelpViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/10/26.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

class HelpViewController: ViewController, UIWebViewDelegate {

    @IBOutlet weak var helpWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.helpWebView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let favoriteURL = NSURL(string: "https://github.com/inai17ibar/sight_on_ios/blob/master/webpage.md")
        //let favoriteURL = NSURL(string: "http://asahina-laboratory.blogspot.jp/2016/04/swift-nsunknownkeyexception.html")
        
        let urlRequest = NSURLRequest(url: favoriteURL! as URL)
        // urlをネットワーク接続が可能な状態にしている（らしい）
        //print(favoriteURL as Any)
        self.helpWebView.loadRequest(urlRequest as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
