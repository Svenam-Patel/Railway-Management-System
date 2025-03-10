# Railway Management System

## Description
A Railway Management System built using DBMS (Database Management System). The system allows users to manage train schedules, reservations, and station information. It supports features like train scheduling, reservation management, and user authentication. The system is designed to be efficient and scalable for a railway organization.

## Features
- **Train Schedule Management**: Add, update, or delete train schedules.
- **Reservation System**: Book, cancel, or modify train reservations.
- **User Authentication**: Register and log in to manage reservations.
- **Admin Interface**: Admins can view all reservations and manage train schedules.
- **Search Functionality**: Search for available trains based on departure and arrival stations.

## Technologies Used
- **DBMS**: SQL Server/MySQL/SQLite (depending on what you used)
- **Backend**: SQL for creating and managing databases and queries
- **Programming Language**: Python/Java (based on the language used in your project)

## Database Schema
The system uses the following tables:
1. **Users**: Stores user details like ID, username, password, and role (user or admin).
2. **Trains**: Stores train information such as train ID, train name, source, destination, and schedule.
3. **Reservations**: Stores reservation details such as user ID, train ID, reservation date, and ticket status.
4. **Stations**: Stores information about stations including station ID and name.
