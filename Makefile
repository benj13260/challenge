IMAGE_REPO ?= "your_repo"
SLACK_URL ?= "https://hooks.slack.com/services/XXXXX/YYYYYYYY/ZZZZZZZ"

local-run:
	@cd configs && make generate-account-list-param-local
	@yarn run dev 

local-run-test-base64:
	@cd configs && make generate-account-list-param-local-64
	@yarn run dev 	

build-image:
	@version=$(grep appVersion charts/Chart.yaml | sed 's/appVersion[: "]*//' | sed 's/"//')
	@echo "Challenge $version"
	@yarn run build || true
	@docker build . -t $(IMAGE_REPO)/challenge:$version -t $(IMAGE_REPO)/challenge:latest
	
push-image:
	@docker push -a $(IMAGE_REPO)/challenge:latest

release:
	@make build-image
	@make push-image	

create-secret-api-url:
	@kubectl create secret generic challenge --from-literal=api-url=$(SLACK_URL)

helm-cmd:	
	@echo "helm install challenge charts/"
	@echo "helm upgrade --install challenge charts/"
	@echo "helm uninstall challenge"

grafana:
	@echo "Connect to: http://localhost:8083/"
	@kubectl port-forward svc/prom-grafana 8083:80
