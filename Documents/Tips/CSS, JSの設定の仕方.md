# CSS, JSの設定の仕方
## 概要
Railsは目的や性格に応じて、CSSやJSファイルを別々のフォルダに配備して、管理するようにしている。これをわからないと、ファイルの読み込みができないし、ファイルの管理もめちゃくちゃになる可能性が高い。

 Railsでは以下のパスでCSSやJSを管理する
	* アプリケーション固有のコードの場合は**app/assets**
	* プロジェクト内でもライブラリ的に扱う場合は**lib/assets**
	* 外部から持ってきたライブラリの場合は**vendor/assets**

これらのパスのファイルを１つのファイルでまとめて読み込む

- application.css
-  application.js

また、`rails generate `コマンドを使ってcontrollerを生成すると、各画面名.sass, jsファイルが生成される。
	- これは、各画面ごとに指定したい時使う。画面がロードされる時適応されること。
		- ⇨ ~つまり、全てのファイルで同じCSS処理、JS処理を行いたい場合はapplication.css / application.jsで宣言すればいいということ。~
- - - -


## CSS

外部で持ってきたやつの場合、フィアるごとに指定をしなければならない。
今回、例として説明するファイルは以下のファイル
```result.html
    <!-- Default stylesheets-->
    <link href="assets/lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Template specific stylesheets-->
    <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Volkhov:400i" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800" rel="stylesheet">
    <link href="assets/lib/animate.css/animate.css" rel="stylesheet">
    <link href="assets/lib/components-font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="assets/lib/et-line-font/et-line-font.css" rel="stylesheet">
    <link href="assets/lib/flexslider/flexslider.css" rel="stylesheet">
    <link href="assets/lib/owl.carousel/dist/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="assets/lib/owl.carousel/dist/assets/owl.theme.default.min.css" rel="stylesheet">
    <link href="assets/lib/magnific-popup/dist/magnific-popup.css" rel="stylesheet">
    <link href="assets/lib/simple-text-rotator/simpletextrotator.css" rel="stylesheet">
    <!-- Main stylesheet and color file-->
```
~~読み込むのが多すぎる…~~

1. 外部CDNなどで読み込むファイル
上記の中で
```
<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed:400,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Volkhov:400i" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800" rel="stylesheet">
```
これらのように、外部で読み込んでいる（CDN)設定ファイルは、application.html.erbの中で作成。

2. .cssのように実際のファイルで管理する場合。
それ以外のファイルは、今回は`app/lib/asset/stylesheets`の中にcssファイル一つ一つを格納する。

3. ファイル使用宣言
ファイルを格納して、すぐ使える訳ではなくて、`applicaiton.css`の中で宣言する必要がある。
```application.css
 *= require_tree 
 *= require_self
 *= require fullcalendar.css
 *= require animate.css
 *= require bootstrap.min.css
 *= require et-line-font.css
 *= require flexslider.css
 *= require font-awesome.min.css
 *= require magnific-popup.css
 *= require owl.carousel.min.css
 *= require owl.theme.default.min.css
 *= require simpletextrotator.css
 *= require style.css
```
	- require_tree : `application.css`と同じファイル階層やその下の階層のファイルたちをTreeと認識し、読み込む。
	- require_self : 自分自身を読み込む ⇨ つまり、全てのHTMLで適応したいなら`application.css`で宣言すること。
	- `app/lib/asset/stylesheets`で格納したファイルは拡張子まで書くこと。

- - - -



## JavaScript

概念はCSSと同じ。
::※JSは一般的に`<body>`の中の下の部分に記述する。::
```Result.html
<!--  
    JavaScripts
    =============================================
    -->
    <script src="assets/lib/jquery/dist/jquery.js"></script>
    <script src="assets/lib/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="assets/lib/wow/dist/wow.js"></script>
    <script src="assets/lib/jquery.mb.ytplayer/dist/jquery.mb.YTPlayer.js"></script>
    <script src="assets/lib/isotope/dist/isotope.pkgd.js"></script>
    <script src="assets/lib/imagesloaded/imagesloaded.pkgd.js"></script>
    <script src="assets/lib/flexslider/jquery.flexslider.js"></script>
    <script src="assets/lib/owl.carousel/dist/owl.carousel.min.js"></script>
    <script src="assets/lib/smoothscroll.js"></script>
    <script src="assets/lib/magnific-popup/dist/jquery.magnific-popup.js"></script>
    <script src="assets/lib/simple-text-rotator/jquery.simple-text-rotator.min.js"></script>
    <script src="assets/js/plugins.js"></script>
    <script src="assets/js/main.js"></script>

```
~~JSもクソ多い~~

1. 外部CDNなどで読み込むファイル
今回は外部CDNはないけど、もしあれば`application.html.erb`  で記載すること。

2. .jsのように実際のファイルで管理する場合。
それ以外のファイルは、今回は`app/lib/asset/javascripts`の中にjsファイル一つ一つを格納する。

3. ファイル使用宣言
ファイルを格納して、すぐ使える訳ではなくて、`applicaiton.js`の中で宣言する必要がある。
```application.js
//= require rails-ujs
//= require activestorage
//= require jquery.js
//= require bootstrap.min.js
//= require wow.js
//= require jquery.mb.YTPlayer.js
//= require isotope.pkgd.js
//= require imagesloaded.pkgd.js
//= require jquery.flexslider.js
//= require owl.carousel.min.js
//= require smoothscroll.js
//= require jquery.magnific-popup.js
//= require jquery.simple-text-rotator.min.js
//= require plugins.js
//= require main.js
//= require_tree .
```
宣言する順番については、基本的は元のテンプレートに記載されていた順にすればいい。
::※ jqueryを先に読み込んでから、bootstrapを読まないとbootstrapが適応されないので注意すること。::

## もしこの後、ファイルがないとかのエラーが発生する場合…
```
couldn’t find file ‘jquery.js’ with type ‘application/javascript’
Checked in these paths: 
```
上記のようなエラーが発生して、何かわからないけど、ファイルパスみたいなことが記載されていると、
`app/lib/asset/`のパスが存在するか、確認すること。
	なければ、パスの指定が必要。
	⇨ PJで使用すると宣言したファイルを見つけなくてエラー発生。

`config/initializer/assets.rb`の中に、
`Rails.application.config.assets.paths << Rails.root.join('lib/asset/stylesheets')`これを入れましょう。
*jsが問題なら、jsに合わせたパスを記載すること。*


以上。


