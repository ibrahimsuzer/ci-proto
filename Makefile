SERVICE:=cinkstone-proto
COMMIT_ID:=$(shell git rev-parse --short HEAD)
REVISION_ID:=$(shell git rev-list --count HEAD)
BRANCH:=$(shell git symbolic-ref --short HEAD)
TAG:=$(shell git describe --tags | sed 's/-g[a-z0-9]\{7\}//')
MESSAGE:=$(shell git log -1 --pretty=%B)

VER_PROTOBUF:=3.6.1
VER_GRPCWEB:=1.0.3
VER_GRPC-GO:="1.2.0"

all: cleanup

install:
	## Protoc install
	wget https://github.com/protocolbuffers/protobuf/releases/download/v${VER_PROTOBUF}/protoc-${VER_PROTOBUF}-linux-x86_64.zip -O ./protoc.zip
	unzip -o ./protoc.zip -d /usr/local bin/protoc
	chmod +x /usr/local/bin/protoc

	## Install NPM Packages
	npm install


	## Install GRPC Web Plugin
	wget https://github.com/grpc/grpc-web/releases/download/${VER_GRPCWEB}/protoc-gen-grpc-web-${VER_GRPCWEB}-linux-x86_64 -O ./protoc-gen-grpc-web
	mv -n ./protoc-gen-grpc-web /usr/local/bin/protoc-gen-grpc-web
	chmod +x /usr/local/bin/protoc-gen-grpc-web

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

doc:
	@mkdir -p docs
	@go get github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc
	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--doc_out=./docs \
		--doc_opt=html,proto.html \
		./general/*.proto
	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--doc_out=./docs \
		--doc_opt=json,proto.json \
		./general/*.proto
	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--doc_out=./docs \
		--doc_opt=markdown,proto.md \
		./general/*.proto

js:
	@mkdir -p out
	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--js_out=import_style=commonjs:./out \
		--grpc-web_out=import_style=commonjs,mode=grpcwebtext:./out \
		--include_imports --include_source_info --descriptor_set_out=./out/proto.pb \
		./general/*.proto
	@echo ${TAG} >/tmp/tag
	@echo ${MESSAGE} >/tmp/message


go:
	@mkdir -p out
	@go get github.com/golang/protobuf/protoc-gen-go
	# Until go modules support installing binaries to GOBIN
	# https://github.com/golang/go/issues/24250
	@GO111MODULE=off go get github.com/golang/protobuf/protoc-gen-go
	@go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
	@go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger

	@protoc \
		-I=./node_modules/google-proto-files \
		-I. \
		--go_out=plugins=grpc:./out \
		--grpc-gateway_out=logtostderr=false:./out \
		--swagger_out=logtostderr=false:./out \
		--include_imports --include_source_info --descriptor_set_out=./out/proto.pb \
		./general/*.proto
	@echo ${TAG} >/tmp/tag
	@echo ${MESSAGE} >/tmp/message

java-lite:
	@mkdir -p out
	cp -Rfp --parents ./general/*.proto ./out
	@echo ${TAG} >/tmp/tag
	@echo ${MESSAGE} >/tmp/message

java:

obj-c:

swift:

cleanup:
