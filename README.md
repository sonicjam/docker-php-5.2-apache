Docker container of PHP 5.2 with Apache
=======================================

PHP 5.2 と Apache 環境の Docker コンテナ生成用の Dockerfile です。

提供する機能は次の通りです:

* CentOS 5 環境
* Apache 2 環境
* PHP 5.2 環境
* PHP GD 対応
* PHP PDO 対応
    * MySQL (`mysql-devel`)
    * PostgreSQL (`postgresql-devel`)
    * Oracle 11g (Oracle Instant Client 11.2)
    * SQLite (`sqlite-devel`)


準備
----

Oracle Instant Client をダウンロードして同じディレクトリ内に置いておく必要があります。

* [Oracle Instant Client Downloads](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)

次のファイルをダウンロードして、このファイルと同じ階層に保存して下さい:

* `oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm`
* `oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm`


コンテナ作成
------------

次の Docker コマンドでコンテナを作成できます:

```
docker build -t sonicjam/php-5.2-apache ./
```


コンテナ実行
------------

次の Docker コマンドでコンテナを実行できます:

```
docker run \
    -d \
    -p 49160:80 \
    -v ${HOME}:/data \
    -v ${PROJ_DIR}/htdocs:/var/www/html \
    sonicjam/php-5.2-apache
```

上記コマンドでコンテナを起動した場合;

- ローカルマシン上の HTTP 待受ポートとして `49160` 番を設定
- `$HOME` ディレクトリが仮想サーバー上の `/data` としてマウント
- `$PROJ_DIR/htdocs` ディレクトリが仮想サーバー上の www ルートディレクトリとしてマウント

としてコンテナをバックグラウンドで実行します。


メンテナ
--------

Yu Inao <yu.inao@sonicjam.co.jp>
