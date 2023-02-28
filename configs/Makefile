generate-account-list-param-local-64:
	@sed -i '/^ACCOUNTS=/d' ../.env
	@echo "ACCOUNTS=" > ../.env.tmp
	@cat accountsList.json | tr -d [:space:] | base64 | tr -d [:space:] >> ../.env.tmp
	@cat ../.env.tmp | tr -d '\n'  >> ../.env
	@rm ../.env.tmp || true
