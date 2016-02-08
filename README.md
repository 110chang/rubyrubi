# Rubyrubi

Yahoo!形態素解析を利用して文字列を解析し、ルビ関係のタグを振って返します。

[日本語形態素解析](http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html)

## Installation

```ruby
gem 'rubyrubi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyrubi

## Usage

```ruby
rubyrubi = Rubyrubi::Client.new(YOUR_API_KEY) 
rubyrubi.furu(YOUR_TEXT)
```

出力例

```html
<ruby>青<rp>（</rp><rt>あお</rt><rp>）</rp></ruby>い<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgment

このgemは私の作成した初めてのgemです。
ファイル構造等[Rubyfuri](https://github.com/karur4n/rubyfuri)をベースにさせていただきました。

