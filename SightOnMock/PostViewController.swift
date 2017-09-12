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
    @IBOutlet weak var dismissButton: UIButton!
    let temp_data = TemporaryDataManager()
    let database = DatabaseAccessManager()
    var currentControllerName = "Anonymous"
    
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        database.create(file_path, dataName: "新しい音_"+getNowClockString(), userId: 1, tags:["fun", "happy", "hot"])
        database.add()
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let now = Date()
        return formatter.string(from: now)
    }


    @IBAction func buttonTapped(_ sender : Any)
    {
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }
        
        postButton.setTitle("保存されました．フィード画面に移動します.", for: .normal)
        post()

        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func dismissButtonTapped(_ sender : Any)
    {
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }
        dismissButton.setTitle("保存をキャンセルしました．録音画面に戻ります.", for: .normal)
        print("dismiss")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        var className = "\(self)"
        className = className.components(separatedBy: ".").last!
        className = className.components(separatedBy: ":").first!
        print("current:"+className)
        //print(className == "AutoEditViewController" )
        if UIDevice.current.orientation.isLandscape && (className == "PostViewController"){
            //print("Post Landscape")
            gotoManual()
        } else {
            //print("Post Portrait")
        }

    }
    func gotoManual(){
        print(currentControllerName)
        if currentControllerName == "AutoEdit"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ManualEdit") as! ManualEditViewController
            nextViewController.currentControllerName = "Post"
            self.present(nextViewController, animated:true, completion:nil)
        }else if(currentControllerName == "ManualEdit") {
            self.dismiss(animated: true, completion: nil)
            /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ManualEdit") as! ManualEditViewController
            nextViewController.currentControllerName = "Post"
            self.present(nextViewController, animated:true, completion:nil)
 */
        }
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
