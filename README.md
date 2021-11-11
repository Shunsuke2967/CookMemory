# CookMemory
*CookRecipeの内容をUbuntu環境で改善してweb上で公開しました
もとにしたコード↓<br>
https://github.com/Shunsuke2967/CookRecipe
<br>
<br>
## 初めてwebに公開したまとめ<br>
### もとのコードから変更した点・追加点
- webに公開するためにherokuを利用しました
- herokuではpostgresqlを推奨していたため使用するデータベースを変更しました
- アプリの使い方と題名がすれ違っていたため使用目的にあった題名に変更した
- 公開する前にデザインを最低限整えました
- 携帯に対応していなかったためレシポンシブ対応にしました
- ニックネームカラムの追加
### 苦労した点
- windowsだとgemのpgが入らなかったためWSLに開発環境を移しました
- cssをうまく使いこなせなくて思いどうりのデザインになるまで時間がかかった
- レスポンシブ対応するのにブラウザごとデザインが崩れたりして調整が難しかった

### 反省点
- 公開を早くしたいためにherokuに接続する設定部分のコードはほぼコピペだったのでしっかり理解する
- Ubuntuのコマンド操作があやふやなので積極的に使って覚える
- cssの設計がいい加減で付け足していってしまったせいでぐちゃぐちゃになったので最初にアプリの構成を組み立てる時間を作る

### 感想

最初のアプリの設計とデータベースの設計がいかに大切かがわかりました<br>
今回のコードの書き方だと後から見返したり修正したりがかなり難しくなった<br>


