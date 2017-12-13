server {
    listen       80;
    server_name  m.jinqiao360.com www.m.jinqiao360.com;

    charset utf-8;
    root /home/rong/www/jinqiao/webroot;

    access_log  logs/m.jinqiao.access.log;

    if ($host = 'm.jinaiqo360.com' ) {
        rewrite ^/(.*)$ http://www.m.jinqiao360.com/$1 break;
    }

    location / {
        index  index.html index.htm index.php;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    location ~ /static/ {
        rewrite "^/static/(.*)$" /static/$1 break;
    }

    # 不记录 favicon.ico 错误日志
    location ~ (favicon.ico){
        log_not_found off;
        expires 100d;
        access_log off;
        break;
    }

    # 静态文件设置过期时间
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
        expires 100d;
        break;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #location ~ \.php$ {
    location ~ / {
        rewrite "^(.*)$" /index.php  break;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /home/rong/www/jinqiao/webroot/m.php;
        include        fastcgi_params;
    }
}
