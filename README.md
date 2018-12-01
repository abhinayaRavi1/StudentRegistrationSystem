# StudentRegistrationSystem
A simple menu based student registration application using JDBC and PL/SQL
This system can be used to enroll students into a class, drop enrollments, list the prerequisites for a given course,delete student records and display the tables in the database.

Oracle JDBC driver version - 11.1.0

## Files:

packspec.sql - File which contains procedure declarations.
packbody.sql - File which contains procedure definitions.
trigger.sql - File which contains triggers and a sequence for populating logs table.
studentRegistrationSystem.java - Java source file which connects to the database and fetches record based on the user input.

## Instructions to run the files

Load the appropriate data.

Oracle side
SQL> start packspec.sql
SQL> start packbody.sql
SQL> start trigger.sql

Once these files are compiled run the Java file in the appropriate classpath
> javac studentRegistrationSystem.java
> java studentRegistrationSystem
