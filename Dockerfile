FROM python:3.11-alpine

WORKDIR /app

RUN apk update && apk upgrade --no-cache && \
    pip install --no-cache-dir --upgrade pip setuptools

COPY app.py .


RUN adduser -D appuser
USER appuser

EXPOSE 8080

CMD ["python", "app.py"]
