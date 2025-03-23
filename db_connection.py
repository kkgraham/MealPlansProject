import psycopg2
from psycopg2 import Error
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import os
import logging


def configure():
    load_dotenv()

def db_connection():
    try:
        connection = psycopg2.connect(
            host=os.getenv('pg_host'),
            dbname='mealplans',
            user=os.getenv('pg_user'),
            password=os.getenv('pg_pass'),
            port=5432
        )
        print("Connection Successful")
        return connection

    except Error as e:
        print("Error Connecting")
        return None
    
def close_connection(connection):
    if connection:
        connection.close
        print("Connection Successfuly Closed")

def test_connection():
    connection = db_connection()

    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute('SELECT version();')
            db_version = cursor.fetchone()[0]
            print(f'Connected to PostgreSQL: {db_version}')
            cursor.close()

            cursor.close()
            return True

        except Error as e:
            print(f'Error connecting to Database: {e}')
            return False
        
        finally:
            close_connection(connection)

    return False

if __name__ == "__main__":
    configure()
    test_connection()
