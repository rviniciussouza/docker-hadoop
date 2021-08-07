.PHONY: build
VERSION = 3.3.1
DOCKER_NETWORK = hadoop-cluster_hadoop-network
PARAMS_FILE_APP = submit-params.env
build:
	@docker build -t rvinicius/base-node-hadoop:${VERSION} ./base
	@docker build -t rvinicius/master-node-hadoop:${VERSION} ./master
	@docker build -t rvinicius/worker-node-hadoop:${VERSION} ./worker
	@docker build -t rvinicius/client:${VERSION} ./application 

submit:
	@docker build -t app ./application
	@docker run --network ${DOCKER_NETWORK} --env-file ${PARAMS_FILE_APP} -v /home/vinicius/hadoop-cluster/data:/data app