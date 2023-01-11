FROM debian:buster-slim
RUN apt update && apt full-upgrade -y && apt autoremove -y
RUN apt install -y curl sudo
COPY automated-install .
RUN bash automated-install
