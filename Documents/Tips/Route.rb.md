# Route.rb

RailsでのRoute.rbは, あるページの処理をどのControllerのAction(Method)に紐つけるのかを定義するファイルです。

> Route  
> 道  



```ruby
Rails.application.routes.draw do
  
  root 'login_page#login' #homepage
  
  get 'result/show'
  get 'main_page/create'
  get 'main_page/show'
  get 'login_page/login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```


上記の設定はうちのPJの設定です。

簡単に宣言しているのですが、RailsのController - View を考えるとすぐイメージできると思います。

- - - -

Railsは「名前」でデータの送受信先を探したりするパターンが多いです。

例）

- Controller : Result Controller -> show method

- View : Result フォルダー -> show.html.erb
  get 方式でresultのshowにアクセスしたデータは、Result Controllerのshow メソッドで処理する
  などで解釈できます。

例外として、他のルートを指定したい場合は、下記のように明示的に宣言も可能です。
`get 'result/show' => 'result#show'`

また、あるデータを指定したい場合も宣言できます。
例）
`post 'tags/:tag' => 'posts#index'`
上記は tag というある値をアドレスに乗せてPost controllerのindex メソッドで処理するという意味です。

- - - -
#### resources

route.rbでは`resources`というキーワードを使えます。
RailsはRESTfulな概念が実装されています。
[Railsを支える基本概念の整理（RESTfulやリソースなど） - Qiita](https://qiita.com/kidach1/items/43e53811c12351915278#rest%E3%81%A8%E3%81%AF)

ま、簡単にいうと、CRUDとHTTPのget, post, put, deleteを紐つけて、
WEBの基本？ルールに従って正しい実装ができるようにする仕組みです。

`resources :posts`
とroute.rbに宣言すると、postモデルについて、get, post, put, deleteのアクセス方式を勝手にしてくれます。
ちなみに、resourcesが対応する、メソッドの名前は下記の通りです。

- index

	- show
	
- new

- create

- update

- edit

- delete

   です。上記のメソッド名がControllerに宣言されていると、resourcesキーワードで適切にget, post, put, delete方式を割り当てくれます。

※ページを実行し、アドレスの後ろに`/rails/routes`を入れて遷移してみてください。
現在のウェブで宣言されているパスの一覧が表示されます。また、そのアドレスに対応するControllerのMethodも表示されます。





参考資料
[Railsを支える基本概念の整理（RESTfulやリソースなど） - Qiita](https://qiita.com/kidach1/items/43e53811c12351915278)

 [https://railstutorial.jp/chapters/a-demo-app?version=4.0#sec-a_user_tour](https://railstutorial.jp/chapters/a-demo-app?version=4.0#sec-a_user_tour)

 

