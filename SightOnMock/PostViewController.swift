//
//  PostViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

class PostViewController: ViewController {

    @IBOutlet weak var postButton: UIButton!
    
    let temp_data = TemporaryDataManager()
    let database = DatabaseAccessManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post()
    {
        let file_path = temp_data.loadDataPath()
        //let url = URL(fileURLWithPath: file_path)
        print("post")
        database.create(file_path, dataName: "テスト", userId: 1, tags:["fun", "happy", "hot"])
        database.add()
    }

    @IBAction func buttonTapped(_ sender : Any)
    {
        post()
        postButton.setTitle("finish posted", for: .normal)
        //強制遷移をつける？
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        var className = "\(self)"
        className = className.components(separatedBy: ".").last!
        className = className.components(separatedBy: ":").first!
        print(className )
        //print(className == "AutoEditViewController" )
        if UIDevice.current.orientation.isLandscape && (className == "PostViewController"){
            //print("Post Landscape")
            gotoManual()
        } else {
            //print("Post Portrait")
        }

    }
    func gotoManual(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ManualEdit")
        //let nextViewController =  ViewController(nibName: ManualEditViewController, bundle: nil)
        if let controllersOnNavStack = self.navigationController?.viewControllers{
            let n = controllersOnNavStack.count
            print(n)
        }
        self.present(nextViewController, animated:true, completion:nil)
        
        //_ = navigationController?.popViewController(animated: true)
        //    self.dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
