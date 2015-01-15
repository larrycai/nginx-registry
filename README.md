# Nginx authentication proxy, works with private docker registry #

* HTTP Basic Auth
* LDAP Authentication

Below links are referred:

* Dockerfile is based on https://github.com/opendns/nginx-auth-proxy for nginx env, but totally changed for this
* nginx config is referred https://github.com/docker/docker-registry/issues/747#issuecomment-64952999 
* https://github.com/docker/docker-registry/tree/master/contrib/nginx
* https://calvin.me/nginx-ldap-http-authentication/ 
* http://www.allgoodbits.org/articles/view/29

Try to run nginx docker container in front of registry container

## HTTP Basic Authentication

Mostly it follows the blog [Building private Docker registry with basic authentication](
https://medium.com/@deeeet/building-private-docker-registry-with-basic-authentication-with-self-signed-certificate-using-it-e6329085e612)

""" All the certifications inside are generated for demo purpose inside. """

It works successfully under boot2docker windows environment.

You need to append `dokk.co` (testing domain name) in  `/etc/hosts`'s `localhost`

    127.0.0.1 boot2docker localhost localhost.local dokk.co
	
Download and add [ca.pem](https://github.com/larrycai/nginx-auth-proxy/blob/master/) into your ca trust list.

    $ cat ca.pem | sudo tee -a /etc/ssl/certs/ca-certificates.crt
    $ sudo /etc/init.d/docker restart

Then you can start two docker containers to try
	
    $ docker run -d --name registry -p 5000:5000 registry
	$ docker run -d --name nginx --link registry:registry -p 443:443 larrycai/nginx-registry
	
It recommend to put `docker-registry.htpasswd`,`server.crt`,`server.key` put local directory like `/registry-key` and passed via tag `volume`

    $ docker run -d --name registry -p 5000:5000 registry
	$ docker run -d --name nginx -v /registry-key:/data --link registry:registry -p 443:443 larrycai/nginx-registry	
	
### Verify ###

open browser to access https://192.168.59.103 , it shall show the nginx https works fine.

Now verify the https basic auth is ok

	$ curl -i -k https://larrycai:passwd@dokk.co
	
Then we see `docker push` is ok

    $ docker login -u larrycai -p passwd -e "test@gmail.com" dokk.co
	$ docker pull hello-world
	$ docker tag hello-world dokk.co/hello-world
	$ docker push dokk.co/hello-world
	$ docker pull dokk.co/hello-world
	
## LDAP Authentication	

With the help of 3rd nginx module [nginx_auth_ldap](https://github.com/kvspb/nginx-auth-ldap), it can be configured to have LDAP authentication.

Below is the sample how it works with simple LDAP server, surely you need to adjust the configuration for your own solution.

### Verify ###

It use another docker image [larrycai/openldap](https://registry.hub.docker.com/u/larrycai/openldap/) as sample

    $ docker run -d --name registry -p 5000:5000 registry
	$ docker run -d -p 389:389 --name ldap -t larrycai/openldap
	$ docker run -d --name nginx --link ldap:ldap --link registry:registry -p 443:443 -p 3443:3443 larrycai/nginx-registry	
	
Then you can repeat the verification like basic authentication. (don't forget to change `dock.co` to `dock.co:3443`)


