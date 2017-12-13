# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts

server{
   listen       80;
   server_name  app.rong360.com;
   root /home/rong/www/trunk/webroot;
   index index.php;

 
   location ~ /static/ {
	  access_log   logs/static.log   common;
      rewrite ^/static/(.*)$ /static/$1 break;
   }
 
   location ~ /robots.txt {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
    }

   location ~ /favicon {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
    }

   location ~ / {
      rewrite ^(.*)$ /index.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/app.php;
      include fastcgi_params;
   }

}



