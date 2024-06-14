# Build Docker images
docker build -t your-registry/grpc-server:latest -f server/Dockerfile .
docker build -t your-registry/grpc-client:latest -f client/Dockerfile .

# Push Docker images to registry
docker push your-registry/grpc-server:latest
docker push your-registry/grpc-client:latest
