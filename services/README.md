# RabbitMQ Message Types

## Message Types

```bash
username="$(kubectl get secret testing-rabbitmq-default-user -o jsonpath='{.data.username}' | base64 --decode)"
password="$(kubectl get secret testing-rabbitmq-default-user -o jsonpath='{.data.password}' | base64 --decode)"
service="$(kubectl get service testing-rabbitmq -o jsonpath='{.spec.clusterIP}')"
```

```bash
kubectl run receive-pod --image quintindk/rabbitmq-dotnet:0.0.1 -- sh -c "export RABBITMQ_HOST=$service;export RABBITMQ_USERNAME=$username;export RABBITMQ_PASSWORD=$password;dotnet run -p Receive/Receive.csproj"

kubectl run send-pod --image quintindk/rabbitmq-dotnet:0.0.1 -- sh -c "export RABBITMQ_HOST=$service;export RABBITMQ_USERNAME=$username;export RABBITMQ_PASSWORD=$password;dotnet run -p Send/Send.csproj"
```