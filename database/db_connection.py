import psycopg2
from psycopg2 import Error
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import os


def configure():
    load_dotenv()

def connect():
    configure()
    try:
        connection = psycopg2.connect(
            host=os.getenv('pg_host'),
            dbname='mealplans',
            user=os.getenv('pg_user'),
            password=os.getenv('pg_pass'),
            port=os.getenv('pg_port')
        )
        print("Connection Successful")
        return connection

    except Error as e:
        print("Error Connecting")
        return None
    
def execute_query(connection, query, params=None):
    try:
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        if params:
            cursor.execute(query, params)
        else:
            cursor.execut(query)

        if query.strip().upper().startswith("SELECT"):
            return cursor
        
        connection.commit()
        print("Successfully executed query")
        return True

    except Error as e:
        print("Failed to execute query")
        return False
    
    finally:
        if 'cursor' in locals() and not query.strip().upper().startswith('SELECT'):
            cursor.close()

def close_connection(connection):
    if connection:
        connection.close
        print("Connection Successfuly Closed")

def test_connection():
    configure()
    connection = connect()

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