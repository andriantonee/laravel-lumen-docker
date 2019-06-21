TAG				:= ${CI_COMMIT_SHA}
SITE_APP_IMG	:= ${AWS_SITE_APP_REPOSITORY}:${TAG}
WEB_SERVER_IMG	:= ${AWS_WEB_SERVER_REPOSITORY}:${TAG}

build:
	@docker build --tag ${SITE_APP_IMG} --target build ./site-app
	@docker build --tag ${WEB_SERVER_IMG} --target build .

push:
	@ecs-cli push ${SITE_APP_IMG}
	@ecs-cli push ${WEB_SERVER_IMG}
