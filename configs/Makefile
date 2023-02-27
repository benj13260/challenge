clean-up:
	@sed -i '/^ACCOUNTS=/d' ../.env && sed -i '/^BASED=/d' ../.env

generate-account-list-param-local:
	@make clean-up
	@echo 'BASED="false"' >> ../.env
	@cat accountsList.json | tr -d [:space:] >> ../.env
	@sed -i 's/{/ACCOUNTS={/' ../.env

generate-account-list-param-local-64:
	@make clean-up
	@echo 'BASED="true"' >> ../.env
	@cat accountsList.json | tr -d [:space:] | base64 | tr -d [:space:] >> ../.env
	@sed -i 's/^ey/ACCOUNTS=ey/' ../.env
