.PHONY: all
all: deploy-test

# When run locally DOCKER_TAG won't be set so we should create it
# When run in Jenkins the Jenkinsfile defines this appropriately
setup:
ifndef DOCKER_TAG
DOCKER_TAG = "localtest-$(shell git rev-parse --short HEAD)"
endif

deploy-test: setup
	docker build -f Dockerfile.test -t $(DOCKER_TAG) .
	docker run --rm $(DOCKER_TAG)

deploy-dev: setup
	docker build -f Dockerfile.deploy -t $(DOCKER_TAG) .
	docker run -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY) -e DIST_ID=E3EIOU7ZWHCG6N -e S3_BUCKET=ynap-mobile-config --rm $(DOCKER_TAG) src/deploy.sh

deploy-prod: setup
	docker build -f Dockerfile.deploy -t $(DOCKER_TAG) .
	docker run -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY) -e DIST_ID=EICW1U3RX3V6O -e S3_BUCKET=mobile-config.services.ext.net-a-porter.com --rm $(DOCKER_TAG) src/deploy.sh
