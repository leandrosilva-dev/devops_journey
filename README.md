# devops_journey
# Python environment

## Create a Virtual Environment
python3 -m venv venv
source venv/bin/activate

## Install application
pip install -r requirements.txt

## Run the application
python3 app.py

## Find out which application is running on a port
sudo lsof -i :5000

## Active virtual environment
source venv/bin/activate

## Run tests
deactivate
rm -rf venv
pip cache purge
python3 -m venv venv
source venv/bin/activate
pip install --no-cache-dir -r requirements.txt
pytest test_app.py