FROM debian:buster-slim

RUN apt update && apt full-upgrade -y && apt autoremove -y

RUN apt install -y curl sudo

COPY automated-install .

RUN bash automated-install

RUN ln -sf /dev/stderr /usr/local/nginx/logs/error.log && ln -sf /dev/stdout /usr/local/nginx/logs/access.log

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
