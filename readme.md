docker-lamp
===========

A docker container for mounting a website and mysql data directories into it. This sets up a docker container for
running a typical lamp setup. It mounts both the code for the website and the mysql data directory. If your site is 
configured by an .htaccess file, all you should have to do is mount both directories and configure your site to use the
correct mysql server. This is the information for connecting to mysql:

- database = `app`
- user = `app`
- password = `app_password`
- host = `127.0.0.1`

Once you have everything configured, launch the container. I happen to run [unmark][1] using this container and I have it
setup on `/var/unmark`. The php files are at `/var/unmark/app` and the mysql data directory is `/var/unmark/mysql`. To
run it, I run:

    docker run -d -p 127.0.0.1:8001:80 -v /var/unmark/app:/var/www -v /var/unmark/mysql:/var/lib/mysql btobolaski/lamp
    
[1]:https://github.com/plainmade/unmark

I have nginx on the Docker host setup as a reverse proxy, this is the configuration that I use.

```
server {
  listen 80;
  server_name unmark.tobolaski.com;
  location / {
    proxy_pass http://127.0.0.1:8001;
    proxy_redirect off;
    proxy_buffering off;
    proxy_set_header 	Host	$host;
    proxy_set_header 	X-Real-IP	$remote_addr;
    proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
  }
}
```

If you have a simple app, you can simply pull this from the Docker index. Its btobolaski/lamp. If you have a remotely
complex app, you should probably clone this repo and modify the settings as needed.
