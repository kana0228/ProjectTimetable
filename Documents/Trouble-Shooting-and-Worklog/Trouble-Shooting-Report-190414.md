# Trouble Shooting Report

## 2019/4/14

### select タグで、Categoryのidをどうやって渡すのか。

```ruby
	<% for option in @category do %>
      <option value="<%= option.id %>"> <%= option.category_val %> </option>
  <% end %>  
```
上記のようにしても、valueの値はちゃんと渡されたが、`form_for` タグし修正したため、ちょっと表現を修正しました。

```ruby
<%= f.select :category_id, Category.all.map{|o| [o.category_val, o.id]} %>
```
selectタグの`name`属性を、`category_id`とします。
そして、`value`として、`Category`モデルのすべての値を出力します。`option`の`value`として、`o.id`が設定されます。逆順に見えますが、気をつけましょう。

- - - -



### EventオブジェクトにCategoryのidがうまく挿入されなかった。

この件に関しては、[[N:N関係設定]]を参考してください。

- - - -



### Form_forのデータが意図したメソッドに飛びなかった１

理由は不明でしたが、`form_for`に処理すべきメソッドのパスを明示的に宣言して解決しました。
`<%= form_for @event,:url => {:action => :create } do |f| %>`
actionはcreateに行ってくださいとのことです。　処理するメソッド名を書いとくと、`routes.rb`に宣言されている
パスを辿って処理をします。

- - - -


### Form_forのデータが意図したメソッドに飛びなかった 2

今度はデータの値までは確認していなかったけど、ゴミ値っていうか、意図しなかったデータが入っていたらしくて、挿入するデータをコントロールしました。
`ForbiddenAttributesError`というエラーが出ていました。
要するに、railsって、同じ名前であればソースを適当に書いても勝手にやってくれるけど、名前が合わない値を入れようとするとエラーが出ちゃうことが結構あります。
`@event = Event.new(params[:event])`
こうすることで、`event`という配列のデータをEventオブジェクトに入れることができるけど、配列の中に、オブジェクの性格（コラム）とあっていない値（存在しない名前）などの値が含まれていると、エラーを出す。

なので値を設定する際、`permit()`メソッドを使って、挿入する値を強制的に宣言し、挿入することができる。
`Event.new(params[:event].permit(:time_from, :time_to, :content, :category_id, :useless_flag))`
上記のコードだと、event配列で、`time_from, time_to, content, category_id, useless_flag`の値だけ使いますと宣言および制限することになります。

---

参考資料
[Rails 4.x FormのSelect プルダウンメニューの項目をDBから引っ張ってくる方法 - Qiita](https://qiita.com/colorrabbit/items/b58888506e41d1370fd1)
[https://stackoverflow.com/questions/18853721/first-argument-in-form-cannot-contain-nil-or-be-empty-rails-4](https://stackoverflow.com/questions/18853721/first-argument-in-form-cannot-contain-nil-or-be-empty-rails-4) 
[undefined method `***_path’となる現象の解決策 - gaku様の備忘録](http://gaku3601.hatenablog.com/entry/2014/08/30/101125)
[【Rails】パラメータからcreateするときにはまったところメモ - Qiita](https://qiita.com/s-mori/items/d1b90d35fac26190c695)
[Ruby - undefined method `save’エラーで詰まってしまいました。。｜teratail](https://teratail.com/questions/138844)


