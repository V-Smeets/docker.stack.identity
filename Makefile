#
STACK_NAME	= identity

deploy: docker-compose.yml
	docker stack deploy --compose-file docker-compose.yml ${STACK_NAME}

undeploy:
	docker stack rm ${STACK_NAME}
	-docker container wait `docker container ls --filter label=com.docker.stack.namespace="${STACK_NAME}" --quiet`
	docker system prune --all --filter label=com.docker.stack.namespace="${STACK_NAME}" --volumes --force
