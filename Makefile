SERVICE=cinkstone-proto
COMMIT_ID=$(shell git rev-parse --short HEAD)
REVISION_ID=$(shell git rev-list --count HEAD)
BRANCH=$(shell git symbolic-ref --short HEAD)
TAG=$(shell git describe --abbrev=0 --tags --broken)

all: cleanup

install:

lint:

lock:

js:

go:

java:

obj-c:

cleanup:
