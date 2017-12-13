# may add here your
# server {
#	...
# }
# statements for each of your virtual hosts
server{
   listen       80;
   server_name  gl.rong360.com;
   root /home/rong/www/data/gl;
   index index.html;
   location ~ /static/ {
	  root /home/rong/www/trunk/webroot;
   	  expires 1y;
      rewrite ^/static/(.*)$ /static/$1 break;
   }

location ~ ^/uploads/ {
	        rewrite ^(.*)$  http://www.rong360.com/gl/$1 permanent;
			expires 3h;
}


    rewrite  '/a/([0-9]{4})/(.*)$'  http://www.rong360.com/gl/$1/$2 permanent;
    rewrite  '/a/(.*)/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  http://www.rong360.com/gl/$2/$3/$4/$5 permanent;
    rewrite  '/a/(.*)/$'  http://www.rong360.com/gl/$1/ permanent;

    location ~ / {
        rewrite  ^(.*)$  http://www.rong360.com/gl/ permanent;
    }


   rewrite  '^/a/jingyingdaikuan/gouchedaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/wudiyadaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/diyadaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/zhuanjiawenda/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/xinshoudaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/xiaofeidaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/goufangdaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;
   rewrite  '^/a/jingyingdaikuan/jingyingdaikuangonglue/([0-9]{4})/([0-9]{2})([0-9]{2})/(.*)$'  /a/$1/$2/$3/$4 permanent;

   rewrite  ^/a/jingyingdaikuan/(.*)$ /a/$1 permanent;


#location ~ ^/gl/ {
#        #rewrite  '(.*)$' http://www.163.com break;
#        #rewrite '//gl/(.*)$'  $1 break;
#        rewrite ^/gl/(.*)$  http://gl.rong360.com/$1 break;
#}


   location ~ /favicon {
      rewrite ^/(.*)$ /$1 break;
   }

   location ~ /*\.html  {
     rewrite ^(.*)$ /$1  break;
   }

   location ~ /a/  {
     rewrite ^(.*)$ /$1  break;
   }
   location ~ /uploads/  {
     rewrite ^(.*)$ /$1  break;
   }
   location ~ /images/  {
     rewrite ^(.*)$ /$1  break;
   }

   location ~ /count {
      rewrite ^(.*)$ /cms.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/cms.php;
      include fastcgi_params;
  }
   location ~ /search {
      rewrite ^(.*)$ /cms.php break;
      fastcgi_pass   127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/cms.php;
      include fastcgi_params;
  }
 #  location ~ / {
 #     rewrite ^(.*)$ /cms.php break;
 #     fastcgi_pass   127.0.0.1:9000;
 #     fastcgi_param  SCRIPT_FILENAME  /home/rong/www/trunk/webroot/cms.php;
 #     include fastcgi_params;
 # }
																					     
}
