# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts
server{
   listen       80;
   server_name  3g.rong360.com;
   root /home/rong/www/trunk/webroot;
   index rong360.php;

   location ~ /static/ {
	  access_log   logs/static.log   common;
	  expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
    }

   location ~ / {
      rewrite ^(.*)$ /rong360.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/rong360.php;
      include fastcgi_params;
   }
   
}



