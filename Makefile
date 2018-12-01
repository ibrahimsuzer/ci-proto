SERVICE=cinkstone-proto
COMMIT_ID=$(shell git rev-parse --short HEAD)
REVISION_ID=$(shell git rev-list --count HEAD)
BRANCH=$(shell git symbolic-ref --short HEAD)
TAG=$(shell git describe --abbrev=0 --tags --broken)

PROTOBUF=3.6.1

all: cleanup

install:
	## Protoc install
	wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF}/protoc-${PROTOBUF}-linux-x86_64.zip -O ./protoc.zip
	unzip -o ./protoc.zip -d /usr/local bin/protoc
	chmod +x /usr/local/bin/protoc

	## Install NPM Packages
	npm install
	npm version ${TAG} --force --allow-same-version --no-git-tag-version

lint:
	@go get github.com/ckaznocha/protoc-gen-lint@v0.2.1
	@protoc \
	-I=./node_modules/google-proto-files \
	-I. \
	--lint_out=. \
	./general/*.proto

lock:

js:

go:

java:

obj-c:

cleanup:
