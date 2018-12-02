SERVICE=cinkstone-proto
COMMIT_ID=$(shell git rev-parse --short HEAD)
REVISION_ID=$(shell git rev-list --count HEAD)
BRANCH=$(shell git symbolic-ref --short HEAD)
TAG=$(shell git describe --tags --broken | sed 's/-g[a-z0-9]\{7\}//')

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
	@go get github.com/ckaznocha/protoc-gen-lint
	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--lint_out=. \
		./general/*.proto

lock:
	@go get github.com/nilslice/protolock
    # Until go modules support installing binaries to GOBIN
    # https://github.com/golang/go/issues/24250
	@GO111MODULE=off go get github.com/nilslice/protolock/...
	@protolock status

js:

go:

java:

obj-c:

swift:

cleanup:
