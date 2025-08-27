FROM debian:latest

RUN apt update && \
    apt -y install sendmail sasl2-bin

COPY smtp-auth-creds /etc/mail
RUN makemap hash /etc/mail/smtp-auth-creds < /etc/mail/smtp-auth-creds

COPY sendmail.mc-part /root

RUN sed -i '27r/root/sendmail.mc-part' /etc/mail/sendmail.mc
RUN sed -ie 's/Port=smtp, Addr=127.0.0.1/Port=smtp/g' /etc/mail/sendmail.mc

RUN make -C /etc/mail

EXPOSE 25
CMD ["/usr/sbin/sendmail", "-bD", "-q10s", "-D", "/dev/stdout"]
