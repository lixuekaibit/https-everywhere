server{
   listen       80;
   server_name  edb.rong360.com;
   root /home/rong/www/trunk/webroot;
   index edb.php;

   location ~ /static/ {
	  access_log   logs/static.log   common;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ /robots.txt {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ / {
      rewrite ^(.*)$ /edb.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/edb.php;
      include fastcgi_params;
   }
}
