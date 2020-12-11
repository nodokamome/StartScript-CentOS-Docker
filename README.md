# StartScript-CentOS-Docker
さくらのVPSスタートアップスクリプで公開しているスクリプトですが、こちらでも公開します。

使用する際に以下入力してください。
- ユーザ（ADMIN_NAME）
- ユーザのパスワードADMIN_PASSWORD
- SSHのアクセスポート番号（SSH_PORT）

## 環境
- CentOS7
- さくらのVPS
    - 公開鍵を選択してスタートアップスクリプt実行

## やってくれること
- yum update
- ユーザ設定
- ユーザのパスワード設定（rootパスワードは、インストール開始時に設定）
- 公開鍵認証
- ssh設定
- Docker,Docker-Composeインストール

※公開鍵を登録して実行してください。

## 参考
▼スタートアップスクリプト
https://manual.sakura.ad.jp/vps/startupscript/startupscript.html

▼公開鍵認証
https://manual.sakura.ad.jp/vps/controlpanel/ssh-keygen.html
