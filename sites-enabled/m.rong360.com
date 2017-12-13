# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts
server{
   listen       80;
   server_name  m.rong360.com;
   root /home/rong/www/trunk/webroot;
   index mobile.php;

   location ~ /static/ {
	  access_log   logs/static.log   common;
	  expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /zysns {
	   rewrite ^/(.*)$ http://m.rong360.com/?utm_source=sns&utm_medium=1sns&utm_campaign=zysns;
   }

   location ~ /wxcs/calc {
	   rewrite ^/(.*)?(.*)$ http://m.rong360.com/app/calculator/?utm_source=wxcs&utm_medium=wap&utm_campaign=wxcs$2 permanent;
   }

   location ~ /wxcs {
	   rewrite ^/(.*)?(.*)$ http://m.rong360.com/?utm_source=wxcs&utm_medium=wap&utm_campaign=wxcs$2 permanent;
   }

   location ^~  /msns {
	   rewrite ^/(.*)$  http://m.rong360.com/?utm_source=SNS&utm_medium=1sns&utm_campaign=20130913  permanent;                                                  
   }   

   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
    }
   location ~ /credit/{
      rewrite ^(.*)$ /index.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/mobile_credit.php;
      include fastcgi_params;
   }


   location ~ / {
      rewrite ^(.*)$ /mobile.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/mobile.php;
      include fastcgi_params;
   }
   
}



