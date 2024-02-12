# RealWorld API

[conduit](https://demo.realworld.io/#/)のクローンサイトです。

フロントのリポジトリは
<https://github.com/makoto00000/realworld_nextjs>

## ローカルでの起動方法

```shell
rails s
```

上記のコマンドで起動し、[https://localhost:3001]を開いてRailsの画面が開けば成功です。
（サイトを表示するには、フロント側を起動しておく必要があります。）

## AWSへデプロイ

現在、<https://suscle.com>でインターネット上へ公開しています。

## アーキテクチャ図

![アーキテクチャ図](https://github.com/makoto00000/realworld_api/assets/65654634/fd1bab7f-cfe0-4f14-bfce-be091545e512)

## 実施したこと

- AWS EC2へデプロイ
- RDSを作成
- 独自ドメインと紐づけ
- HTTPS化（HTTPアクセス時は301リダイレクト）
- github Actionsを用いたCI/CDの構築
