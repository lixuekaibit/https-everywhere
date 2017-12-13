server{
   listen       80;
   server_name  bd.rong360.com;
   root /home/rong/www/trunk/webroot;
   index bd.php;

   location ~ /static/ {
	  access_log   logs/static.log   common;
      expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ / {
      rewrite ^(.*)$ /bd.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/bd.php;
      include fastcgi_params;
   }
}
