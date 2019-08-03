# Trouble Shooting Report

## 2019/03/31

### inputタグなどが見えない現象があった。

- 枠や警戒線？がちゃんと見えなかった現象があった。
	⇨ Chrome Developer Toolで login pageが上書きされていたのが確認。
- 問題としては、Application.css で全CSSを読み込み、そこでまとめているからわけ分からなくなってきたということかなと。
- `*= require_tree .`を削除した。
- 現段階で、うちのファイルは全部名前で結びつけられている。
	Controller name - View Name - CSS name - JS name 
が全部一緒。統一されている。
- なので、Railsが勝手にしてくれると思っただけで。笑い

参考サイト
[css - My stylesheets in Rails seem to be overlapping - Stack Overflow](https://stackoverflow.com/questions/33189474/my-stylesheets-in-rails-seem-to-be-overlapping)

- - - -

### FullCalendarが表示されなかった

- application.jsの中で、JQueryを重複して読んでいた。
	- `//= require Jquery.js` で、libの中のファイルを読んでいたけど、
	- `//= require_tree .` で、`/app/assets/javascripts/`の中のJquery3.3.1.jsというやつを読んでいた。
		- Jquery3.3.1.js削除。
		-  ちなみにmain_page.jsも削除した。なんとなく。


参考サイト
[jQueryの多重読み込みは、原則として　ダメ　ゼッタイ - Qiita](https://qiita.com/m-shin/items/8b946727188e8fb58e53)

---

### Login Page

ログインページでFontawesomeの読み込みがうまく行っていない。
CORSの問題と思われる。（Chrome Developer ToolsのConsoleのエラーで検索した結果。）
gemfileにcors関連gemを記載して、設置はしたが、うまくいかない。AmazonCloud9の問題かもしれない。
他の方法を探した方が早いかもしれないし、もしくは他のTemplateを入れたり、直接実装した方もあり得る。


