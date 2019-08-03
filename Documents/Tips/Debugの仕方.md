# Debugの仕方
### rails c
簡単に、ターミナルでrailsのコンソルを開くことができます。
Linuxのターミナルのように、railsの簡単なコマンドを使えます。
簡単に値を設定して、メソッドや動きがどう動くか確認するにはいいと思います。
ターミナルで`rails c`を入力してできます。

- - - -

### logger.debug

Rails?ルビーが提供する簡単なdebugツールです。
ソースが実行されると自動的に実行されます。
変数の値や処理の流れが知りたいところに使用できます。
```
def index
  if true then
     logger.debug("if文の中に入りました")
  end
end

```
などにして、サーバを起動して、ログを確認すると、上記の処理が動く際に、サーバのログ上に表示されます。
`logger.debug(event.inspect)`このようにすると、eventというオブジェクトのデータまで見れます。
また、`log/development.log`が生成されるらしいです。



参考資料
[Railsでlogを出力しdebugする - Qiita](https://qiita.com/Kashiwara/items/f8a4030da6b17e96fabf)

