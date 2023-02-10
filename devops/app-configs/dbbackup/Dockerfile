FROM mdillon/postgis:10
RUN apt update -y
RUN apt install -y python-pip
RUN pip install awscli
COPY do_backup.sh /
RUN chmod +x /do_backup.sh