from flask import Flask, jsonify
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

def greet(name):
    """Returns a greeting message."""
    if not name:
        return "Hello, Guest!"
    return f"Hello, {name}!"

@app.route('/')
def home():
    """Home endpoint."""
    return "Welcome to the DevOps Demo App!"

@app.route('/greet/<name>')
def greet_api(name):
    """API endpoint to greet a user."""
    message = greet(name)
    return jsonify({"message": message})

if __name__ == '__main__':
    port = int(os.getenv('APP_PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)