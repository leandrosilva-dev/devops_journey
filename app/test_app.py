import pytest
from app import greet, app

# Unit test for the greet function
def test_greet_with_name():
    assert greet("Alice") == "Hello, Alice!"

def test_greet_without_name():
    assert greet("") == "Hello, Guest!"

def test_greet_with_none():
    assert greet(None) == "Hello, Guest!"

# Unit test for the home endpoint (Flask test client)
def test_home_endpoint():
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b"Welcome to the DevOps Demo App!" in response.data