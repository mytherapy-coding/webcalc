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
  http://localhost:8000/api/save
```

```sh
curl -X GET \
  http://localhost:8000/api/{short_url_id}
```


