server{
   listen       80;
   server_name  daili.rong360.com;
   root /home/rong/www/daili/webroot;
   index index.php;

   location ~ /static/ {
      expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ / {
      rewrite ^(.*)$ /index.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/daili/webroot/index.php;
      include fastcgi_params;
   }
}
