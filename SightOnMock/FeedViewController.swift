//
//  FeedViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var audioPlayer:AVAudioPlayer!
    var sounds:Results<Sound>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //既存データでの読み込みテスト
        let audioPath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        print("\(audioPath)")
        
        //DBから読み込んで表示する場合
        let realm = try! Realm()
        sounds = realm.objects(Sound.self).filter("userId == 1") //%@, val 非Optional型はnilが入らない
        //var soundUrls = sounds.filter( {(x: Sound) -> URL in return URL(fileURLWithPath: x.file_path)})
        
        
        //TODO: 要シングルトン化
        // auido を再生するプレイヤーを作成する
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
        }
        catch{
            print("Error: cannot init audioPlayer")
        }
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
            
            let url = URL(fileURLWithPath: sounds[indexPath.row].file_path)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                
            }catch{
                print("Error: cannot play audioPlayer")
            }
            
            //サンプル
            cell.titleLabel.text = "\(indexPath.row)"
            let image:UIImage = UIImage(named:"sample")!
            cell.photo = UIImageView(image:image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    //あるセルを押したら再生
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        else{
            audioPlayer.play()
        }
    }
    
    // 音楽再生が成功した時に呼ばれるメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {}
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {}
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
