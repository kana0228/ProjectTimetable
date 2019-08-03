# Trouble Shooting Report

## 2019/3/16

### サーバが起動しなかったり、おかしくなった。

	- 正直、現状のPJってまだ何もできてないところなのでPJ消して新しく作ってからやり直した。Gitは繋いでいない。**注意すること。**



### rails g controllerができない（応答しない場合）

	- command promptで`Spring stop` で解決



### Syntax error

```
- ActionView::Template::Error (SyntaxError: [stdin]:5:3: reserved word 'function'):
     5:     <%= csrf_meta_tags %>
     6:     <%= csp_meta_tag %>
     7: 
     8:     <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
     9:     <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
    10:   </head>
    11: 
  
(execjs):7539:8
(execjs):7545:14
`app/views/layouts/application.html.erb:8:in _app_views_layouts_application_html_erb__927917784985356171_42274940'``
```
 ~~coffeeScriptの文法問題（`function`が予約語だから使用できない）~~ 

### CSSとJSを設定すること。

今日の作業はここがめっちゃ難しかった。
[CSS, JSの設定の仕方](../Tips/CSS, JSの設定の仕方.md)

- - - -

## 作業状況
現状、エラーなしに**表示は**される
1. ログイン画面
レイアウト崩れ発生している。CSSの調整が必要。
2. mainページ
	- Calendarが表示されない。railsに合う方法で適応しなければいけない。
		- gemが必要。場合によってはcssとjsを予め配備する必要があるかと思う。[Rails5でFullCalendarの実装 - Qiita](https://qiita.com/mediocreRail/items/49ae4b951926c0b20db3)
	- 細かいinputタグがちゃんと表示されていない。
		- RailsのForm_tagの中では決まっているルールがある。ルールに沿った表現文法を使う。
		- inputタグの修正が必要。
3. Result画面
	- グラッフがちゃんと表現できない。
		- グラッフのアイコンがない。Faviconを入れなかったからかも。
		- グラッフ処理できない。JSの問題か？

以上。

