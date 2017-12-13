# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts

limit_req_zone $binary_remote_addr zone=reqlow:20m rate=10r/s;
limit_req_zone $binary_remote_addr zone=reqhigh:20m rate=500r/s;

server{
   listen       80 default_server;
   server_name  www.rong360.com rong360.com;
   root /home/rong/www/trunk/webroot;
   index index.php;

 	if ($host = 'rong360.com' ) {
	  rewrite ^/(.*)$ http://www.rong360.com/$1  permanent;
	}

    location ~ /credit/api/v1/{
        proxy_redirect off ;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        client_max_body_size 50m;
        client_body_buffer_size 256k;
        proxy_connect_timeout 30;
        proxy_send_timeout 30;
        proxy_read_timeout 60;
        proxy_buffer_size 256k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;
        proxy_temp_file_write_size 256k;
        proxy_next_upstream error timeout invalid_header http_500 http_503 http_404;
        proxy_max_temp_file_size 128m;

        proxy_pass    http://cluster;
        }


	location ~ /static/u.gif {
		access_log  logs/u.gif.log common; 
	}
	location ~ /pgtxyk
	{
		rewrite ^/(.*)$ http://www.rong360.com/credit/?fr=hp_daohang_xinyongka&utm_source=pgt&utm_medium=cpa&utm_campaign=pgtcpa permanent;
	}
	location ~ /pgtitunes
	{
		rewrite ^/(.*)$ https://itunes.apple.com/cn/app/wo-yao-ban-xin-yong-ka-rong360/id694973296?mt=8 permanent;
	}

	location ~ /pgt{
		rewrite ^/(.*)$  http://www.rong360.com/?utm_source=pgt&utm_medium=push&utm_campaign=pgtpush permanent;
	}

	location ~ /ipadmini {
		rewrite ^/(.*)$ http://www.rong360.com/?utm_source=mobile&utm_medium=2sns&utm_campaign=zqsns permanent;
	}

	location ~ /ipad {
		rewrite ^/(.*)$ http://www.rong360.com/?utm_source=mobile&utm_medium=1sns&utm_campaign=zysns permanent;
	}

	location ~ /dxcs {
		rewrite ^/(.*)$ http://t.agrantsem.com/tt.aspx?cus=307&eid=1&p=307-16-8212a051776accff.06c4c7b7eaf34eef&d=http%3a%2f%2fwww.rong360.com%2f%3futm_source%3ddx%26utm_medium%3dwap%26utm_campaign%3ddxwap permanent;
	}

	location ~ /mini/sohu{
		return 500;	
	}

	location ~ /baidu_verify_zPUsMfODmb.html {
		access_log   logs/static.log   common;
		rewrite ^/(.*)$ /$1 break;
	}

	location ^~ /ask/ {
      rewrite ^(.*)$ /index.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/ask.php;
      include fastcgi_params;
	}

	location ~ /licai/wb/ {
       		root /home/rong/www/trunk/rong360/licai/plugin/weibo/sina/;
       		fastcgi_pass   127.0.0.1:9000;
       		rewrite ^/licai/wb/(.*)$ /$1.php break;
       		fastcgi_index index.php;
       		fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/rong360/licai/plugin/weibo/sina/$fastcgi_script_name;
       		include fastcgi_params;
   	}

   	location ~ /licai/qq/ {
       		root /home/rong/www/trunk/rong360/licai/plugin/weibo/qq/;
       		fastcgi_pass   127.0.0.1:9000;
       		rewrite ^/licai/qq/(.*)$ /$1.php break;                                                                                                               
       		fastcgi_index index.php;
      		 fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/rong360/licai/plugin/weibo/qq/$fastcgi_script_name;
       		include fastcgi_params;
   	}

		location ~ /licai/ {
		rewrite ^(.*)$ /index.php break;
	       	fastcgi_pass   127.0.0.1:9000;
       		fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/licai.php;
		include fastcgi_params;
	}

	location ~ /ceaia.bin {
		rewrite ^/(.*)$ /$1 break;
	}


   location ^~ /dl/ {
	root /home/rong/www/download/;
      	rewrite ^/dl/(.*)$  /$1 break;
   }

   location ~ /static/ {
	  access_log   logs/static.log   common;
      limit_req zone=reqhigh burst=30 nodelay;
      expires 30d;
      rewrite ^/static/(.*)$ /static/$1 break;
   }
   location ~  /credit/ {
	   rewrite ^(.*)$ /index.php break;
	   fastcgi_pass   127.0.0.1:9000;
	   fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/credit.php;
	   include fastcgi_params;
   }   

   location ^~ /gonglue/ {
      rewrite ^/(.*)$  /cms.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/cms.php;
      include fastcgi_params;
    }

   location ^~ /gl/ {
        if ($host != 'www.rong360.com')
        {
                return 404;
        }
        root /home/rong/www/data/;
        index index.html;
        rewrite ^/(.*)$ /$1 break;
    }

   location ~ /favicon {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
    }
   
    location ~ /bdsitemap.txt {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
    }
    
	location ~/wooyun_verify.txt {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
    }
    
    location ~ /BingSiteAuth.xml {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }
    
    location ~ /google0e85d957cf841c78.html {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }
    
   location ~ /googled1b082785251f24f.html {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }

    location ~ /wb_9d618d0a22e53443.txt {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }
    
   location ~ /webscan_360_cn.html {
	  access_log   logs/static.log   common;
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ /bd/ {
      rewrite ^(.*)$ /index.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/bd.php;
      include fastcgi_params;
   }
   
   #location ~ /mis/ {
   #   rewrite ^(.*)$ /index.php break;
   #   fastcgi_pass   127.0.0.1:9000;
   #   fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/mis/index.php;
   #   include fastcgi_params;
   #}

#   location ~ /app/ {
#      rewrite ^(.*)$ /index.php break;
#      fastcgi_pass   127.0.0.1:9000;
#      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/app.php;
#      include fastcgi_params;
#   }

   location ~ /bank/logo.html {
	  access_log   logs/static.log   common;
      expires 30m;
      rewrite ^(.*)$ /index.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/rong360.php;
      include fastcgi_params;
   }
   
   location ~ / {
      limit_req zone=reqlow burst=15 nodelay;
      rewrite ^(.*)$ /index.php  break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/rong360.php;
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

