import database.db_connection as db_connection

from interface.interface_initialize import InitializeInterface

def main():
    db_connection.connect()
    # db_connection.test_connection()
    # interface = InitializeInterface()
main()