# Infrastructure as Code

## Getting Started

* Install Terraform

## Build

```bash
terraform init
terraform plan -v ./.env/dev.tfvars
terraform apply
```

## RabbitMQ

```bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
```

```bash
kubectl krew install rabbitmq
kubectl rabbitmq create testing-rabbitmq
kubectl krew install tail

username="$(kubectl get secret testing-rabbitmq-default-user -o jsonpath='{.data.username}' | base64 --decode)"
password="$(kubectl get secret testing-rabbitmq-default-user -o jsonpath='{.data.password}' | base64 --decode)"
service="$(kubectl get service testing-rabbitmq -o jsonpath='{.spec.clusterIP}')"

echo "username: $username"
echo "password: $password"

kubectl rabbitmq manage testing-rabbitmq
```

[http://localhost:15672/](http://localhost:15672/)

```bash
kubectl run perf-test --image=pivotalrabbitmq/perf-test -- --uri amqp://$username:$password@$service
```
