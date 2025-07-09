# Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container at /app
COPY app.py .

# Expose port 5000 (the port Flask runs on by default)
EXPOSE 5000

# Define environment variable for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run the Flask application
# Use gunicorn for production-ready deployment
# gunicorn is a WSGI HTTP Server for UNIX. It's more robust than Flask's built-in server.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]