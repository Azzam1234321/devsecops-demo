FROM python:3.11-alpine

WORKDIR /app


RUN apk update && apk upgrade --no-cache && \
    pip uninstall -y setuptools pip && \
    rm -rf /usr/local/lib/python3.11/ensurepip

COPY app.py .

RUN adduser -D appuser
USER appuser

EXPOSE 8080

CMD ["python", "app.py"]

