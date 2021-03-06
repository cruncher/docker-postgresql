all: build

build:
	@docker build --tag=cruncher/postgresql:$(shell cat VERSION) .

release: build
	@docker build --tag=cruncher/postgresql:$(shell cat VERSION) .

push: release
	@docker push cruncher/postgresql:$(shell cat VERSION)

