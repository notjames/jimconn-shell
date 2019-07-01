all: run
.PHONY: all

setup-docker:
	@docker build -t nginx:jimconn build/nginx > /dev/null 2>&1

run: setup-docker
	@docker run -dv ${PWD}:/opt --name nginx nginx:jimconn > /dev/null 2>&1
	@bin/makesucks
	@docker stop nginx > /dev/null 2>&1
	@docker rm nginx > /dev/null 2>&1
