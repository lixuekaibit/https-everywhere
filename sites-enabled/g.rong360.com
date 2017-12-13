server{
   listen       80;
   server_name  g.rong360.com;
   root /home/rong/www/trunk/webroot/static/;

   add_header Cache-Control no-cache;
   add_header Cache-Control private;
   expires -1s;

   location ~ /u.gif {
      log_format  new_log  '$remote_addr $remote_user [$time_local] $request $http_cookie';
      access_log   /home/rong/nginx/logs/dpf.log new_log;
   }

   location ~ /t.gif {
      access_log   /home/rong/nginx/logs/loadtime.log;
   }

   location ~ /favicon {
      access_log off;
   }
}
