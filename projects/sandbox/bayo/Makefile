all: setup-docker run
.PHONY: all

setup-docker:
	@docker build -t nginx:jimconn build/nginx

run:
	@docker rm nginx > /dev/null 2>&1 || true
	@docker run -dv ${PWD}:/opt --name nginx nginx:jimconn
	@bin/makesucks
clean:
	@docker stop nginx > /dev/null 2>&1
	@docker rm nginx > /dev/null 2>&1