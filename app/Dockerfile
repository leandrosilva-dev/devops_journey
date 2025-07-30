# Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.12-slim-bookworm

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get clean

# Copy the requirements file into the container at /app
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && rm -rf /root/.cache/pip

FROM python:3.9-alpine

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/

COPY app.py .

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Use gunicorn for production-ready deployment
# gunicorn is a WSGI HTTP Server for UNIX. It's more robust than Flask's built-in server.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]