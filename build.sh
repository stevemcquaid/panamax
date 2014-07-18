### EX:
### bash build.sh n18-smcquaid.dev-godaddy.com wp18-smcquaid.dev-godaddy.com ncd18-smcquaid.dev-godaddy.com rda18-smcquaid.dev-godaddy.com

HELLOWORLDNODEHOST=$1
WORDPRESSHOST=$2
NODECHATDOCKEREXAMPLEHOST=$3
RAILSDOCKERARBEITHOST=$4

#will stop all running docker containers. In a future version this will be converted to a zero-downtime deployment
docker stop $(docker ps -a -q)


### Run a dockerized nginx reverse proxy which will add a virtual host record each time a new docker image is spun up.
DIR=nginx-proxy
REPO=https://github.com/jwilder/nginx-proxy.git
if cd $DIR; then git pull; else git clone $REPO; cd $DIR; fi
docker build -t jwilder/nginx-proxy .
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy
cd ..

### Run dockerized basic node app: stevemcquaid/hello-world-node
DIR=hello-world-node
REPO=https://github.com/stevemcquaid/hello-world-node.git
if cd $DIR; then git pull; else git clone $REPO; cd $DIR; fi
docker build -t smcquaid/hello-world-node .
docker run -d -P -e VIRTUAL_HOST=$HELLOWORLDNODEHOST smcquaid/hello-world-node nodejs /src/hello.js
cd ..

### Run dockerized wordpress: jbfink/docker-wordpress
DIR=docker-wordpress
REPO=https://github.com/jbfink/docker-wordpress.git
if cd $DIR; then git pull; else git clone $REPO; cd $DIR; fi
docker build -t jbfink/docker-wordpress .
docker run -e VIRTUAL_HOST=$WORDPRESSHOST -d -P jbfink/docker-wordpress
cd ..

### Run dockerized node chat client: stevemcquaid/node-chat-docker
DIR=node-chat-docker
REPO=https://github.com/stevemcquaid/node-chat-docker.git
if cd $DIR; then git pull; else git clone $REPO; cd $DIR; fi
docker build -t smcquaid/node-chat-docker .
docker run -d -P -e VIRTUAL_HOST=$NODECHATDOCKEREXAMPLEHOST smcquaid/node-chat-docker nodejs /src/index.js
cd ..

### Run dockerized rails app: stevemcquaid/rails-docker-arbeit
DIR=rails-docker-arbeit
REPO=https://github.com/stevemcquaid/rails-docker-arbeit.git
if cd $DIR; then git pull; else git clone $REPO; cd $DIR; fi
docker build -t stevemcquaid/rails-docker-arbeit .
docker run -d -P -e VIRTUAL_HOST=$RAILSDOCKERARBEITHOST stevemcquaid/rails-docker-arbeit
cd ..

echo "---- Done! ----"