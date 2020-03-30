# nginx-upstream-sandbox

nginx balancer with a simple ruby backend that can play dead.

## bootstrap

Tweak the number of backend instances and their reliability via `docker-compose.yml` command for the `app` service.

Then start the services:

    docker-compose up
    
## features

Access `localhost:3000`, change your nginx config and observe. 
