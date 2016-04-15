# yet another dockerized magento

current magento ce 1.9.2.4 (apache prefork/php)

no db server included, it rather should be --link´ed

### building

clone the repo and run

```sh
docker build -t ymmer/magento:1.0 . > build.log
```
