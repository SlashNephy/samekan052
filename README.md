# samekan052
Twitter ユーザのツイートを素材にして文章を生成するやつ

## Docker Hub

Docker Hub に [@samekan822](https://twitter.com/samekan822) のツイートで学習済のイメージを公開しています。GitHub Actions により1時間おきにフレッシュなツイートで学習され, 自動でイメージとして公開されます。

[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/slashnephy/samekan052/latest)](https://hub.docker.com/r/slashnephy/samekan052)

`docker-compose.yml`

```yaml
version: '3.8'

services:
  app:
    container_name: samekan052
    image: slashnephy/samekan052:latest
    restart: always
    ports:
      - 127.0.0.1:5000:5000/tcp
```

`docker-compose up -d` 後に `http://localhost:5000/api` を叩くと文章が生成されます。

```shell
$ curl http://localhost:5000/api | jq
```

```json
{
  "sentence": "法学部の単位取得率が全く当てにならないんだよｗ"
}
```

## Docker (任意のユーザのツイートを学習する場合)

このリポジトリを clone してきて同じディレクトリに `docker-compose.yml` を作成します。

```yaml
version: '3.8'

services:
  app:
    container_name: samekan052
    build:
      context: .
      args:
        # 学習させる Twitter ユーザのスクリーンネーム (カンマ区切りで複数指定可能)
        USERS: bakarasukun,karasu1231
        # Twitter API 資格情報 (ビルド済イメージには含まれないので安全です)
        TWITTER_CK: xxx
        TWITTER_CS: xxx
        TWITTER_AT: xxx
        TWITTER_ATS: xxx
    restart: always
    ports:
      - 127.0.0.1:5000:5000/tcp
```
