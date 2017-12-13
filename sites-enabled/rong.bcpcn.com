# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts


server{
   listen       80;
   server_name  rong.bcpcn.com;
   root /home/rong/www/trunk/webroot;
   index index.php;

   location ~ /static/ {
	  access_log   logs/static.log   common;
      expires 30m;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

   location ~ /favicon {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /shopex.ico break;
    }

   location ~ /bank/logo.html {
	  access_log   logs/static.log   common;
      expires 30m;
      rewrite ^(.*)$ /index.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/bcpcn.php;
      include fastcgi_params;
   }
   
   location ~ / {
      rewrite ^(.*)$ /index.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/bcpcn.php;
      include fastcgi_params;
   }

	#error_page  404  /404.html;

	# redirect server error pages to the static page /50x.html
	#
	#error_page   500 502 503 504  /50x.html;
	#location = /50x.html {
	#	root   /var/www/nginx-default;
	#}

	# proxy the PHP scripts to Apache listening on 127.0.0.1:80
	#
	#location ~ \.php$ {
		#proxy_pass   http://127.0.0.1;
	#}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	#location ~ \.php$ {
		#fastcgi_pass   127.0.0.1:9000;
		#fastcgi_index  index.php;
		#fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
		#includefastcgi_params;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
		#deny  all;
	#}
}


# another virtual host using mix of IP-, name-, and port-based configuration
#
#server {
#listen   8000;
#listen   somename:8080;
#server_name  somename  alias  another.alias;

#location / {
#root   html;
#index  index.html index.htm;
#}
#}

