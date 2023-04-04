# README

## 開発環境の構築

### local

```
$ git clone
$ docker-compose up -d
```

### デプロイ

- タグのバージョンをあげる

```
$ docker build -t {image:tag} .
$ docker push {image:tag}
```

- google cloud run 上でデプロイ

---

---

## feature branch

- setup go on docker

go 言語を docker 上で動かす

```
$ docker build -t go-docker .
$ docker run -it --name go-container go-docker:1.0
```
