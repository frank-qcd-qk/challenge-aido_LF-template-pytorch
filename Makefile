AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple

build_options=\
 	--build-arg AIDO_REGISTRY=$(AIDO_REGISTRY)\
 	--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL)


repo=challenge-aido_lf-template-pytorch
#repo=$(shell basename -s .git `git config --get remote.origin.url`)
branch=$(shell git rev-parse --abbrev-ref HEAD)
branch=daffy
tag=$(AIDO_REGISTRY)/duckietown/$(repo):$(branch)

build:
	docker build --pull -t $(tag) $(build_options) .

build-no-cache:
	docker build --pull -t $(tag) $(build_options)  --no-cache .

push: build
	docker push $(tag)


update-reqs: 
	pur --index-url $(PIP_INDEX_URL) -r requirements.txt -f -m '*' -o requirements.resolved
	aido-update-reqs requirements.resolved

submit: update-reqs
	dts challenges submit

submit-bea: update-reqs
	dts challenges submit --impersonate 1639 --challenge all --retire-same-label
