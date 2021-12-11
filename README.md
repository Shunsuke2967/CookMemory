# CookMemory
食べた料理を中心に画像と感想を投稿できるサイトです<br>
投稿機能はログインしているユーザーのみ使えるようにしています。<br>
投稿した内容はほかのユーザーと共有できます<br>
レスポンシブ対応なのでスマホからでも確認できます。<br>
<img width="960" alt="スクリーンショット 2021-12-11 192809" src="https://user-images.githubusercontent.com/88970298/145673371-420e311b-c077-426e-ad9d-b684e8fc4fc2.png"><br>
<現在>herokuにて不具合がでたので取り下げています。
<br>
<br>
# 使用技術
- WSL2(開発環境)
- Ruby 2.7.5
- sinatra 2.1.0
- webrick 1.7
- will_pagenate 3.3.1
- sqlite3 1.4.2

# 機能一覧
- ユーザー登録、ログイン、ログアウト機能(sessionを使用し自作)
- 画像投稿機能(sqlite3にパスを保存しファイルに画像データを保存) 
- ページネート(will_pagenate)
- 投稿検索機能
