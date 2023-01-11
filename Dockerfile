FROM debian:buster-slim
RUN apt update && apt full-upgrade -y && apt autoremove -y
RUN apt install -y curl sudo
COPY automated-install .
RUN bash automated-install
RUN ln -sf /dev/stderr /var/log/nginx/error.log && ln -sf /dev/stdout /var/log/nginx/access.log
EXPOSE 80
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
