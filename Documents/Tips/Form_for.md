# Form_for
### FormタグのRails実装
formタグのRailsの実装では、三つぐらいの方法があります。

- form_tag : データを送る対象がない。データを送信するだけで、受信先が決まっていない。
-  form_for : 受信先（だいたいモデル）が決まっている。
- form_with : 最新の文法(Rails 5.1) 上記の二つの表現をまとめて使える。
  			form_withに関しての説明は下記を資料を参考してください。
  			[【Rails 5】(新) form_with と (旧) form_tag, form_for の違い - Qiita](https://qiita.com/hmmrjn/items/24f3b8eade206ace17e2)

#### Form_tag
```ruby
<%= form_tag users_path do %>
  <%= text_field_tag :email %>
  <%= submit_tag %>
<% end %>
```
form_tagは、あるパスに送るだけの処理です。

#### Form_for
```ruby
<%= form_for @user do |form| %>
  <%= form.text_field :email %>
  <%= form.submit %>
<% end %>
```
`form_for`は、あるモデルに対して、値を送ります。
受信先に対しては、railsの`routes.rb`の**基本**宣言通りに送ります。（決まっているパス。）
`form_for`が判断するパスについては、下記の資料を参考してください。

[Route.rb](Route.rb.md)
form内部のtagの使い方（文法）が少し違います。
また、form_forは、モデルに宣言されていないデータ（モデルのコラム以外のデータ）についてはエラーを発生させる可能性があります。
[Trouble Shooting Report - Trouble Shooting Report](bear://x-callback-url/open-note?id=9260712F-C775-4141-9415-A7E2E6E9CBFE-37933-00021883A1933AB1&header=Trouble%20Shooting%20Report)

- - - -

### Form_forの流れ

うちのPJを例として説明しますね。
- `MainPageController > show`
```ruby
class MainPageController < ApplicationController
  def show
    #@category = Category.all
    @event = Event.new
  end
.
.
.
```


`main_page Controller`の実装です。
`show`メソッドの中で、画面に表示するための変数をグローバル変数として宣言しています。
ここで`@event`変数は、`new`だけした、空っぽのオブジェクトです。
次は`show.html.erb`を見てみましょう。



- `show.html.erb`
```ruby
<%= form_for @event,:url => {:action => :create } do |f| %>
	...
<% end %>
```
中で、`form_for`を使っています。ここでの`@event`は、上記の`MainPageController > show`で渡された空っぽのオブジェクトです。
また、`form_for`の処理を`create`に渡すように、明示的に宣言しました。
明示的に宣言した理由についてだ、宣言しないと**パスがありません**などのエラーが出るのですが、原因がわかりませんでしたので…
ここでのデータは`submit` のボタンによって、`create`に送信されます。



- Parameter
```
Processing by MainPageController#create as HTML
  Parameters: {
		"utf8"=>"✓",
		"authenticity_token"=>"oWcZi/cRR3Y689/P+GDK08/nSyL2ZiGaSMF9al1swl9tuNnOFyzjhcqYOPizDCygnu+sWJtGG8wpj0Q/gmknQA==",
		"date"=>"2019-04-09",
		"event"=>{
			"time_from"=>"14:04",
			"time_to"=>"14:05",
			"content"=>"test",
			"category_id"=>"1",
			"useless_flag"=>"0"
		},
		"commit"=>"OK"
	}
```
送信されるデータです。
上記の通り、`form_for`の中でデータは基本的にモデル名の生成された配列に含まれて送信されます。
ただ、`form_for`の表現ではなく、`form_tag`の表現を使ったら、上記の`date`のように、モデル名配列には含まれずに送信されます。



- `MainPageController > create`
```ruby
def create
    time_f = params[:date] + " "+ params[:event][:time_from] #concat date and time_from
    time_t = params[:date] + " " + params[:event][:time_to] #concat date and time_to
    time_f.to_datetime #convert String to Datetime
    time_t.to_datetime #convert String to Datetime
    event = Event.new(time_from:time_f,time_to:time_t,content:params[:event][:content],
    category_id:params[:event][:category_id],useless_flag:params[:event][:useless_flag])
  
    event.save #save the object data to DB　=> Create id and created_time, updated_time automatically.
    redirect_to main_page_show_path
end
```
`view.html.erb` から送信されたデータは`create`に到着します。
ここでは、`params[]`という、メソッドを使って値をコントロールします。
`params[]`のパラメタとしては、基本的に渡されたデータの**名前**です。(`view.html.erb`で設定した`name`属性)
ちなみに、２次元配列または配列のDictionary(Map?)にアクセスする際は`params[][]`として、アクセスできます。

もらったデータを架空したり、`params`で設定したりして、最後に`event.save`をして、DBにコミットします。



- Log
```
(0.1ms)  begin transaction
  ↳ app/controllers/main_page_controller.rb:26
  Event Create (0.6ms)  INSERT INTO "events" ("time_from", "time_to", "content", "category_id", "useless_flag", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?)  [["time_from", "2019-04-09 14:04:00"], ["time_to", "2019-04-09 14:05:00"], ["content", "test"], ["category_id", 1], ["useless_flag", 0], ["created_at", "2019-04-14 02:04:10.790130"], ["updated_at", "2019-04-14 02:04:10.790130"]]
  ↳ app/controllers/main_page_controller.rb:26
   (4.6ms)  commit transaction
  ↳ app/controllers/main_page_controller.rb:26
```
`create`で作成した`new`の流れが、勝手に`insert`文に変換されて、実行されることを確認できます。
ここでの`created_at`や`updated_at`は自動生成されますね。

ここまで、Form_forの流れでした。まだまだ改善できる箇所があると思いますが、上記の説明ならだいたい理解できるかなと思います。
- - - -

### 4月14日時点の、`view.html.erb`のForm_for構造
コメント処理されたコードが多いので、読みづらいかもしれませんので、うちの実装の処理だけ綺麗にして書きときます。
※`div`タグなどは省略
```ruby
<%= form_for @event,:url => {:action => :create } do |f| %>
	<%= date_field_tag :date  %> #@eventには含まれない。
	
	<%= f.label :time_from, "開始時間" %> #ラベル
	<%= f.time_field :time_from %>

	<%= f.label :time_to, "終了時間" %>
	<%= f.time_field :time_to %>

	<%= f.label :content, "内容" %>
	<%= f.text_field :content %>
	
	<%= f.label :category, "カテゴリー" %>
  <%= f.select :category_id, Category.all.map{|o| [o.category_val, o.id]} %> #Categoryの内容を全部出力

	<%= f.label :useless_flag, "無駄" %>
	<%= f.check_box :useless_flag %>
	
	<%= f.submit "OK" %>
<% end %>
```

上記の文法に`class`,`id`などの属性ももちろん指定できます。



参考資料
[【Rails 5】(新) form_with と (旧) form_tag, form_for の違い - Qiita](https://qiita.com/hmmrjn/items/24f3b8eade206ace17e2)
[Rails4においての form_for 最低限の使い方まとめ - Qiita](https://qiita.com/Momozono/items/319bc503e6a5f0963ab9)
[ruby on rails - Saving Date and Time from Form - Stack Overflow](https://stackoverflow.com/questions/42602635/saving-date-and-time-from-form)
 [https://rails-study.net/form_for/](https://rails-study.net/form_for/) 


