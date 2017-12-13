server{
   listen       80;
   server_name  www.jinqiao360.com jinqiao360.com;
   root /home/rong/www/jinqiao/webroot;
   index index.php;

   if ($http_user_agent ~ (iPhone|iPad|Android))    
   {        
      rewrite ^/(.*)$ http://m.jinqiao360.com/$1 break;   
   }

   location ~ /static/ {
      expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ / {
      rewrite ^(.*)$ /bd.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/jinqiao/webroot/index.php;
      include fastcgi_params;
   }
}
