# Rails DB
`Database`は、MVCのModelに当てはまる概念です。

Modelの生成は下記の通り、コマンドで生成します。
`rails generate model モデル名　コラム名：型 ...`
モデル名は、単数形で作成すること。

*※railsでは、単数形と、複数形と区別して使う場面がいくつかあります。。ある程度業界の暗黙的なルールだと思います。*

上記のコマンドを実行すると、
作成した日付_create_モデル名.rbファイルが生成されます。
`20190406061819_create_category_code_masters.rb`



```ruby
class CreateCategoryCodeMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :category_code_masters do |t|
      t.string :category_val

      t.timestamps
    end
  end
end
```


`rails generate model`コマンドで宣言した内容が作成されています。
上記の内容は、テーブルの定義（schema） として認識してもいいと思います。
※schema.rbという、ファイルはあります。

生成したモデルの定義を利用して、実際のDBを生成しなければなりません。

`rake db:migrate`をコマンドラインで実行してください。
migrateは引っ越すなどの意味ですね！

- - - -
DBを設定した後、私たちが管理しやすいように、gemを設置しなければなりません。
`rails_db`というgemが、ある程度OBやSQL Developerなどの役割をします。
この後、アドレスの後ろに`/rails/db`を入力すると、DB管理画面に遷移できます。

テーブルを消したり、コラムを修正するときは、`rake db:drop`を利用して、テーブルを消した後に`rake db:migrate`を再実行してください。

DBに初期データを設定することも可能ですが、
ここは後で…



参考資料
[Rails generate の使い方とコントローラーやモデルの命名規則 - Qiita](https://qiita.com/higeaaa/items/96c708d01a3dbb161f20)


