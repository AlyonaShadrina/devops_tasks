# Test the container locally
```
docker build -t nestjs-rest-api .
docker run -p 3000:3000 nestjs-rest-api
```

You can now access the NestJS app by visiting `http://localhost:3000`.

# Build and push
To clone repo, build and push image to registry run

```
./build_docker_image.sh
```