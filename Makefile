#
STACK_NAME	= identity
SECRET_NAMES	= identity.keycloak.admin.user \
		  identity.keycloak.admin.password \
		  identity.postgres.root.password \
		  identity.postgres.keycloak.user \
		  identity.postgres.keycloak.password

deploy: docker-compose.yml secret
	docker stack deploy --compose-file docker-compose.yml ${STACK_NAME}

undeploy:
	docker stack rm ${STACK_NAME}
	-docker container wait `docker container ls --filter label=com.docker.stack.namespace="${STACK_NAME}" --quiet`
	for secret in $(SECRET_NAMES); \
	do \
		docker secret inspect "$${secret}" >/dev/null 2>&1 && docker secret rm "$${secret}" || true; \
	done
	docker system prune --all --filter label=com.docker.stack.namespace="${STACK_NAME}" --volumes --force

secret: $(SECRET_NAMES)
	for secret in $(SECRET_NAMES); \
	do \
		docker secret inspect "$${secret}" >/dev/null 2>&1 || docker secret create "$${secret}" "$${secret}"; \
	done

identity.keycloak.admin.user:
	echo "admin" >$@
identity.keycloak.admin.password:
	openssl rand -base64 15 >$@
identity.postgres.root.password:
	openssl rand -base64 15 >$@
identity.postgres.keycloak.user:
	echo "keycloak" >$@
identity.postgres.keycloak.password:
	openssl rand -base64 15 >$@
