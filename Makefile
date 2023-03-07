IMAGE_REPO ?= "benjk6"
SLACK_URL ?= "https://hooks.slack.com/services/XXXXX/YYYYYYYY/ZZZZZZZ"

VERSION ?= $(shell grep appVersion charts/Chart.yaml | sed 's/appVersion[: "]*//' | sed 's/"//')

local-run:
	@cd configs && make generate-account-list-param-local-64
	@yarn install 
	@yarn run dev

build-image:
	@echo "Challenge $(VERSION)"
	@docker build . -t $(IMAGE_REPO)/challenge:latest -t $(IMAGE_REPO)/challenge:$(VERSION)

push-image:
	@docker push $(IMAGE_REPO)/challenge:latest

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
