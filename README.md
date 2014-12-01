# Nginx authentication proxy, works with private docker registry #

Below links are referred:

* Dockerfile is based on https://github.com/opendns/nginx-auth-proxy for nginx env, but totally changed for this
* nginx config is referred https://github.com/docker/docker-registry/issues/747#issuecomment-64952999 
* https://github.com/docker/docker-registry/tree/master/contrib/nginx

Try to run nginx docker container in front of registry container

Mostly it follows the blog [Building private Docker registry with basic authentication](
https://medium.com/@deeeet/building-private-docker-registry-with-basic-authentication-with-self-signed-certificate-using-it-e6329085e612)

!!! All the certifications inside are generated for demo purpose inside. !!!

It works successfully under boot2docker windows environment.

You need to append `dokk.co` (testing domain name) in  `/etc/hosts`'s `localhost`

    127.0.0.1 boot2docker localhost localhost.local dokk.co
	
Download and add [ca.pem](https://github.com/larrycai/nginx-auth-proxy/blob/master/) into your ca trust list.

    $ cat ca.pem | sudo tee -a /etc/ssl/certs/ca-certificates.crt
    $ sudo /etc/init.d/docker restart

Then you can start two docker containers to try
	
    $ docker run -d --name registry -p 5000:5000 registry
	$ docker run -d --name nginx --link registry:registry -p 443:443 larrycai/nginx-registry
	
# verify #

open browser to access https://192.168.59.103 , it shall show the nginx https works fine.

Now verify the https basic auth is ok

	$ curl -i -k https://larrycai:passwd@dokk.co
	
Then we see `docker push` is ok

    $ docker login -u larrycai -p passwd -e "test@gmail.com" dokk.co
	$ docker pull hello-world
	$ docker tag hello-world dokk.co/hello-world
	$ docker push dokk.co/hello-world
	$ docker pull dokk.co/hello-world


