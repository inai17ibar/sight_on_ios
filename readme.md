# Readme

## 開発要件
* ViewController(ina)
  * 全画面に共通する基本機能を実装する
    * ダブルタップで録音画面へ
    (Controllerの共通化，Viewの共通化をするならUIViewなどをもとにやったほうがよい？)
* Record ViewController(wake)
  * ホールドして録音開始
  * 離すと録音終了
* Post ViewController(wake, ina)
  * 上スワイプ？で投稿
  * データの保存
* Auto ViewController(wake)
  * ノイズ除去
  * 空白部分の除去
  * 処理中を示すビジュアル
* Manual Edit ViewController(wake)
  * 2つくらいの変数をジェスチャーで変更する
* Feed ViewController(ina)
  * DBの勉強
  * データを読み込んで表示
  * リストビューの実装

## リリースノート
### 価値検証フェーズ
* 2017/08/05 9:00 ReadMeを追加，ボタンによる基本の5画面の遷移を実装