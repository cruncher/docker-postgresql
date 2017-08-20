all: build

build:
	@docker build --tag=cruncher/postgresql .

release: build
	@docker build --tag=cruncher/postgresql:$(shell cat VERSION) .
