# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts
server{
   listen       80;
   server_name  91rongyiji.com www.91rongyiji.com;
   root /home/rong/www/trunk/webroot;
   index index.html;

if ($host = '91rongyiji.com' ) {
	rewrite ^/(.*)$ http://www.91rongyiji.com/$1  permanent;
}

   location ~ /static/ {
	  access_log   logs/static.log   common;
	  expires 1y;
      rewrite ^/static/(.*)$ /static/html/rongyiji/static/$1 break;
   }
location ^~ /dl/ {
	root /home/rong/www/download/;
	rewrite ^/dl/(.*)$  /$1 break;
}


   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
    }

   location ~ / {
	   rewrite  ^(.*)$  /static/html/rongyiji/index.html  break;

   }
}



