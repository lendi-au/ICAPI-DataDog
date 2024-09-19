# Change depending on your environment
PIP := venv/bin/pip3
PYTHON := venv/bin/python3
PYTEST := venv/bin/pytest
IMG_TAG := latest
IMG_REPO := tedk42/ic2datadog
FIND := $(if $(shell which gfind),gfind,find) # needed for macos - do a `brew install findutils` to use gfind

clean:
	rm -rf version output venv

deps:
	python3 -m venv venv
	$(PIP) install -r requirements.txt.lock

update-deps: clean
	docker build . \
		-f Dockerfile.dependencies \
		--tag lendi-airflow-dependencies \
		--rm \
		--progress=plain
	mkdir ./output
	docker run \
		--name lendi-airflow-dependencies \
		--rm \
		--mount type=bind,source="$(CURDIR)/output,target=/output" \
		lendi-airflow-dependencies:latest
	cp ./output/Pipfile.lock ./output/requirements.txt.lock ./

unittest: testing-deps
	$(PYTHON) -m pytest tests/*.py --capture=fd -s

build:
	$(eval version = $(shell cat version))
	docker build --rm --progress=plain . --tag $(IMG_REPO):$(IMG_TAG)
	docker tag $(IMG_REPO):$(IMG_TAG) $(IMG_REPO):$(version)

build-push-testing:
	docker build --rm --progress=plain . --tag $(IMG_REPO):testing
	docker push $(IMG_REPO):testing

lint: deps
	$(PYTHON) -m pycodestyle . --exclude venv && echo "pycodestyle lint ok"
	$(PYTHON) -m pyflakes `$(FIND) -path ./venv -prune -o -name '*.py' -print` && echo "pyflakes lint ok"

push:
	docker push $(IMG_REPO) --all-tags

coverage: testing-deps
	$(PYTEST) --cov=. tests/*.py --capture=no

testing-deps: deps

version: deps
	$(eval version = `$(PYTHON) version.py`)
	echo $(version) > version
	git tag $(version)
	git push --tags

run: deps
	$(PYTHON) ic2datadog.py

.PHONY: unittest deps build push build-push-testing testing-deps
