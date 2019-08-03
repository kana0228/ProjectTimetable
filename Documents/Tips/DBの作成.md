# DBの作成

### ＜開発環境seedの設定コマンド＞

以下のコマンドを順番に
	rails db:drop　←既存のDBを削除
	rails db:migrate　←新規でDBを作成
	rails db:seed 　　←seedで初期値を設定

### ＜herokuへの反映＞

​	git add .
​	git commit -m “[コミットメッセージ]”
​	git push heroku master

​	heroku restart
​	heroku pg:reset DATABAS　←DBをリセット
​		このあと、赤文字で警告文が出るが、pj名を入れて進む。

​	heroku run rake db:migrate　←DBを作成
​	heroku run rake db:seed　←seedで初期値を設定