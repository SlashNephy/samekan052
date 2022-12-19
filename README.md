# samekan052

Twitter ユーザのツイートを素材にして文章を生成するやつ

## Docker

このリポジトリを clone してきて同じディレクトリに `docker-compose.yml` を編集します。

```yaml
version: '3.8'

services:
  app:
    container_name: samekan052
    build:
      context: .
      args:
        # 素材にする Twitter ユーザのスクリーンネーム (カンマ区切りで複数指定可能)
        USERS: samekan822
        # Twitter API 資格情報 (ビルド済イメージには含まれません)
        TWITTER_CK: xxx
        TWITTER_CS: xxx
        TWITTER_AT: xxx
        TWITTER_ATS: xxx
    restart: always
    ports:
      - 127.0.0.1:5000:5000/tcp
```

`docker compose up -d` 後に `http://localhost:5000/api` を叩くと文章が生成されます。

```shell
$ curl http://localhost:5000/api | jq
```

```json
{
  "sentence": "法学部の単位取得率が全く当てにならないんだよｗ"
}
```
