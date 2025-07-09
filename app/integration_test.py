import requests
import time
import os

BASE_URL = os.environ.get('APP_BASE_URL', 'http://localhost:5000')

def test_greet_api_integration():
    """
    Integration test for the /greet/<name> API endpoint.
    """
    time.sleep(2)

    try:
        response = requests.get(f"{BASE_URL}/greet/Bob")
        response.raise_for_status()
        data = response.json()
        assert response.status_code == 200
        assert data["message"] == "Hello, Bob!"
        print(f"Integration test passed for /greet/Bob. Response: {data}")
    except requests.exceptions.ConnectionError as e:
        pytest.fail(f"Integration test failed: Could not connect to the application at {BASE_URL}. "
                    f"Ensure the Flask app is running. Error: {e}")
    except Exception as e:
        pytest.fail(f"Integration test failed: An unexpected error occurred. Error: {e}")

def test_home_api_integration():
    """
    Integration test for the / endpoint.
    """
    time.sleep(1) # Give it a moment

    try:
        response = requests.get(f"{BASE_URL}/")
        response.raise_for_status()
        assert response.status_code == 200
        assert "Welcome to the DevOps Demo App!" in response.text
        print(f"Integration test passed for /.")
    except requests.exceptions.ConnectionError as e:
        pytest.fail(f"Integration test failed: Could not connect to the application at {BASE_URL}. "
                    f"Ensure the Flask app is running. Error: {e}")
    except Exception as e:
        pytest.fail(f"Integration test failed: An unexpected error occurred. Error: {e}")