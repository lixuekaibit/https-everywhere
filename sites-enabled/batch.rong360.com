server{
   listen       80;
   server_name  batch.rong360.com;
   root /home/rong/www/trunk/webroot;
   index batch_api.php;

   location ~ / {
      rewrite ^(.*)$ /batch_api.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/batch_api.php;
      include fastcgi_params;
   }
}
