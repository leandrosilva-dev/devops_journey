#!/bin/bash
set -e

export APP_BASE_URL="http://localhost:36992"

echo "--- Starting Gunicorn Server for Integration Tests ---"
python -m gunicorn --bind 0.0.0.0:36992 app:app &
GUNICORN_PID=$!

echo "Waiting for Gunicorn to start on ${APP_BASE_URL}..."
for i in $(seq 1 15); do
  if curl -s ${APP_BASE_URL} > /dev/null; then
    echo "Gunicorn is up and running!"
    break
  fi
  echo "Waiting... (attempt $i)"
  sleep 1
done

if ! curl -s ${APP_BASE_URL} > /dev/null; then
  echo "Error: Gunicorn did not start within the expected time. Integration tests cannot run."
  kill $GUNICORN_PID || true
  exit 1
fi

echo "--- Running Integration Tests ---"
pytest integration_test.py

echo "--- Tearing down Gunicorn Server ---"
kill $GUNICORN_PID || true
