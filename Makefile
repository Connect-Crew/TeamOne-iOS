.PHONY: generate

module:
	@echo ${name}
	@tuist scaffold feature --name ${name}
