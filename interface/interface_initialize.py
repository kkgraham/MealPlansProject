import os
import sys
from database.db_connection import connect, close_connection, execute_query

class InitializeInterface:
    # Main Interface for Recipe Management System

    def __init__(self):
        self.connection = connect()
        if not self.connection:
            print("Failed to connect to database. Exiting")
            sys.exit(1)

        self.current_menu = self.main_menu
        print("Recipe Management System Started")

    def __del__(self):
        if hasattr(self, 'connection'):
            close_connection(self.connection)

    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def display_header(self):
        self.clear_screen()
        print("=" * 60)
        print("                MEAL PLAN SYSTEM")
        print("=" * 60)
        print()