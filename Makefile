.PHONY: build
VERSION = 3.3.1
build:
	@docker build -t rvinicius/base-node-hadoop:${VERSION} ./base
	@docker build -t rvinicius/master-node-hadoop:${VERSION} ./master
	@docker build -t rvinicius/worker-node-hadoop:${VERSION} ./worker