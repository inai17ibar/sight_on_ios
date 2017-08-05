//
//  FeedViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListItem") as! FeedListItemTableViewCell
            // タイトルの設定
            cell.title_name.text = "\(indexPath.row)"
            // UIImage インスタンスの生成
            let image:UIImage = UIImage(named:"sample")!
            // 画像の幅・高さの取得
            //var width = image.size.width
            //var height = image.size.height
            
            // ImageView frame をCGRectで作った矩形に合わせる
            //cell.photo.frame = rect;
            
            // UIImageView 初期化
            cell.photo = UIImageView(image:image)
            
            // 画像の中心を画面の中心に設定
            //imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
            
            // UIImageViewのインスタンスをビューに追加
            //self.view.addSubview(imageView)
            
            return cell
        }
        return UITableViewCell()
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
