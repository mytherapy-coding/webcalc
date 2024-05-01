### List the contents of an Amazon S3 bucket 
```sh
aws s3 ls static-webcalc-2
```

run server 

```sh
uvicorn main:app --reload 
```

test:

```sh
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"content": "2+5=7"}' \
  http://localhost:10000/api/save
```

```sh
curl -X GET \
  http://localhost:10000/api/{short_url_id}
```


```sh
curl -X GET \
  http://localhost:10000/api/health
```


This command will overwrite reqs.txt with a list of all installed packages and their versions
```sh
pip freeze > reqs.txt
```

### Build a Docker image named webcalc from the current directory 

```sh
docker-compose build
```

```sh
docker buildx build -t webcalc .
```

```sh
docker run -d webcalc
```

```sh
docker ps
```

```sh
docker images
```


### Build abd deploy 

push to DockerHub

```sh
docker tag webcalc mytherapycoding/webcalc:1
docker login
docker push mytherapycoding/webcalc:1
```

