server{
   listen       8088;
   server_name  cache.rong360.com;
   root /home/rong/yunpan/published;
   expires 1d;
   access_log   logs/static.log   common;

}
