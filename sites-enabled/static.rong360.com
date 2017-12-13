server{
   listen       80;
   server_name  static.rong360.com;
   root /home/rong/www/trunk/webroot/static;
   expires 1y;
   access_log   logs/static.log   common;
 
   location ~ /credit/verifycode/{
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

   location ~ /credit/ { 
        root /home/rong/www/data/static;
        rewrite ^/credit/(.*)$ /credit/$1 break;
   }

    location ~ /pimg/pimg/ {
        root /home/rong/yunpan/published;
        rewrite ^/pimg/pimg/(.*)$ /pimg/$1 break;
    }

    location ~ /pimg/ {
        access_log   logs/static.log   common;
        proxy_pass http://127.0.0.1:8088;

        proxy_cache cache1;
        #设置缓存的key 
        proxy_cache_key $host$uri$is_args$args;
        proxy_cache_valid 200 304 10m; 

        #limit_req zone=reqhigh burst=30 nodelay;
        expires 30m;

    }

    # 信贷经理头像
    location ~ /bh-img/ {
        access_log   logs/static.log   common;
        proxy_pass http://127.0.0.1:8088;

        proxy_cache cache1;
        #设置缓存的key 
        proxy_cache_key $host$uri$is_args$args;
        proxy_cache_valid 200 304 10m; 

        #limit_req zone=reqhigh burst=30 nodelay;
        expires 30m;
    }

    # 自定义机构 logo
    location ~ /jigou-img/ {
        access_log   logs/static.log   common;
        proxy_pass http://127.0.0.1:8088;

        proxy_cache cache1;
        #设置缓存的key
        proxy_cache_key $host$uri$is_args$args;
        proxy_cache_valid 200 304 10m;

        #limit_req zone=reqhigh burst=30 nodelay;
        expires 30m;
    }


}
