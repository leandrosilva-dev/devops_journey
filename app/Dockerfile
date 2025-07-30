# Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.12-slim-bookworm

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get clean

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get purge -y \
    libpam-modules \
    libpam-modules-bin \
    libpam-runtime \
    libpam0g \
    perl-base && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get purge -y zlib1g && apt-get autoremove -y

# Copy the application code into the container at /app
COPY app.py .

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Use gunicorn for production-ready deployment
# gunicorn is a WSGI HTTP Server for UNIX. It's more robust than Flask's built-in server.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]