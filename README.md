Doraemon
======

Rackの練習の名の下に作られたネコ型Webフレームワーク

Feature
=======

- 四次元ポケットのように(?)複雑で読みにくいソースコード
- アベコンベのような低い実用性

Usage
=======

```
$ git clone https://github.com/sei0o/doraemon.git
$ cd doraemon
$ rackup -o 0.0.0.0
```

`\ぼくドラえもん/`と表示されればokです。

Example
=========
example.rbを参照のこと。
GETもPOSTもできます。

example.rb
```
get "about" do
  "ぼく<strong>どらえもん</strong>"
end

path "nobita" do
  get "diary" do
    "3/10 ねていた<br>" + 
    "3/11 ねた<br>" +
    "3/12 Rackでフレームワークを作った"
  end
end
```

config.ru
```
require 'colorize'
require 'pp'
require './doraemon'
require './dorayaki'
require './example'

use Dorayaki, 3, 140 # middleware

run method :doraemon
```