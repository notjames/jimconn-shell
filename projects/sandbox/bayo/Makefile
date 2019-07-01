all: setup-docker-network run
.PHONY: all

NETNAME = "dockerNetwork"

setup-docker-network:
  # names containers to be used in docker network creation
	@docker run --name twitter-challenge twitter-challenge:test ls > /dev/null
	@docker run --name nginx nginx:stable ls > /dev/null

  # create docker network
	@docker network create --driver bridge --subnet 172.16.0.0/16 --gateway 172.16.0.1 ${NETNAME}
	@docker network connect --ip 172.16.0.100 ${NETNAME} twitter-challenge
	@docker network connect --ip 172.16.0.200 ${NETNAME} nginx

run:
	@docker-compose up --force-recreate -d

clean:
	@docker-compose down
	@docker network rm dockerNetwork 2>/dev/null || true
	@docker rm nginx twitter-challenge 2>/dev/null || true
	@docker rm $(docker inspect twitter-challenge --format='{{.Config.Hostname}}' 2>/dev/null) 2>/dev/null || true