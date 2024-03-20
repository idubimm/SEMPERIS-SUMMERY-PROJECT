# wait_for_db.py
import os
from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError
import time


DB_USER=      os.environ.get('DB_USER')          or 'idubi'   
DB_PASSWORD=  os.environ.get('DB_PASSWORD')      or 'idubi' 
DB_NAME=      os.environ.get('DB_NAME')          or 'idubi' 
DB_TYPE=      os.environ.get('DB_TYPE')          or  'postgresql' 
DB_HOST=      os.environ.get('DB_HOST')     or 'localhost' 
DB_PORT=      os.environ.get('DB_PORT')     or '5432' 

connection_string= f"{DB_TYPE}://{DB_USER}:{DB_NAME}@{DB_HOST}:5432/{DB_PASSWORD}"

def wait_for_db():
    """Wait for the database to become ready."""
    # Replace the connection string with your actual connection details
    db_url = connection_string
    engine = create_engine(db_url)
    counter = 1
    while True and counter < 10 :
        try:
            # Attempt to connect to the database
            with engine.connect() as conn:
                # Optionally, execute a test query
                result = conn.execute("SELECT 1 from user")
                print("Database is ready:", result.fetchall())
                return
        except OperationalError as error:
            print("Waiting for database...", error)
            time.sleep(500)
            counter = counter+1
        return True

wait_for_db()

