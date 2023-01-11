FROM debian:stable-slim

RUN apt update && apt full-upgrade -y && apt autoremove -y

RUN apt install -y build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev wget libssl-dev

WORKDIR /tmp

RUN wget -O- https://github.com/apache/incubator-pagespeed-ngx/archive/refs/tags/v1.14.33.1-RC1.tar.gz | tar -xz

WORKDIR /tmp/incubator-pagespeed-ngx-1.14.33.1-RC1

RUN wget -O- https://downloads.apache.org/incubator/pagespeed/1.14.36.1/x64/psol-1.14.36.1-apache-incubating-x64.tar.gz | tar -xz

WORKDIR /tmp

RUN wget -O- http://nginx.org/download/nginx-1.22.1.tar.gz | tar -xz

WORKDIR /tmp/nginx-1.22.1

RUN ./configure --add-module=/tmp/incubator-pagespeed-ngx-1.14.33.1-RC1 \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --user=nginx \
  --group=nginx \
  --with-compat \
  --with-file-aio \
  --with-threads \
  --with-http_addition_module \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_realip_module \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-cc-opt='-g -O2 -ffile-prefix-map=/data/builder/debuild/nginx-1.22.1/debian/debuild-base/nginx-1.22.1=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
  --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'

RUN make

RUN make install

RUN useradd -r nginx

RUN mkdir -p /var/cache/nginx/client_temp && chown nginx:nginx /var/cache/nginx/client_temp

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
