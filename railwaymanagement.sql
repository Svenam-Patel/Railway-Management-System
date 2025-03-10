-- Create Database
CREATE DATABASE Railway_Management;
USE Railway_Management;

-- Account Table
CREATE TABLE Account (
    Username VARCHAR(15) PRIMARY KEY,
    Password VARCHAR(20) NOT NULL,
    Email_Id VARCHAR(35) NOT NULL UNIQUE,
    Address VARCHAR(50)
);

-- Contact Table
CREATE TABLE Contact (
    Username VARCHAR(15),
    Phone_No CHAR(10),
    PRIMARY KEY (Username, Phone_No),
    FOREIGN KEY (Username) REFERENCES Account(Username) ON DELETE CASCADE
);

-- Station Table
CREATE TABLE Station (
    Station_Code CHAR(5) PRIMARY KEY,
    Station_Name VARCHAR(25) NOT NULL
);

-- Train Table
CREATE TABLE Train (
    Train_No INT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    Seat_Sleeper INT NOT NULL,
    Seat_First_Class_AC INT NOT NULL,
    Seat_Second_Class_AC INT NOT NULL,
    Seat_Third_Class_AC INT NOT NULL,
    Wifi CHAR(1) NOT NULL,
    Food CHAR(1) NOT NULL,
    Run_On_Sunday CHAR(1) NOT NULL,
    Run_On_Monday CHAR(1) NOT NULL,
    Run_On_Tuesday CHAR(1) NOT NULL,
    Run_On_Wednesday CHAR(1) NOT NULL,
    Run_On_Thursday CHAR(1) NOT NULL,
    Run_On_Friday CHAR(1) NOT NULL,
    Run_On_Saturday CHAR(1) NOT NULL
);

-- Ticket Table
CREATE TABLE Ticket (
    Ticket_No INT AUTO_INCREMENT PRIMARY KEY,
    Train_No INT NOT NULL,
    Date_of_Journey DATE NOT NULL,
    Username VARCHAR(15) NOT NULL,
    FOREIGN KEY (Username) REFERENCES Account(Username) ON DELETE CASCADE,
    FOREIGN KEY (Train_No) REFERENCES Train(Train_No) ON UPDATE CASCADE
);

-- Passenger Table
CREATE TABLE Passenger (
    Passenger_Id INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(20) NOT NULL,
    Last_Name VARCHAR(20),
    Gender CHAR(1) NOT NULL,
    Phone_No CHAR(10),
    Ticket_No INT NOT NULL,
    Age INT NOT NULL,
    Class VARCHAR(20) NOT NULL,
    FOREIGN KEY (Ticket_No) REFERENCES Ticket(Ticket_No) ON DELETE CASCADE
);

-- Stoppage Table
CREATE TABLE Stoppage (
    Train_No INT NOT NULL,
    Station_Code CHAR(5) NOT NULL,
    Arrival_Time TIME,
    Departure_Time TIME,
    PRIMARY KEY (Train_No, Station_Code),
    FOREIGN KEY (Train_No) REFERENCES Train(Train_No) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Station_Code) REFERENCES Station(Station_Code) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Add Constraint for Valid Time Entry in Stoppage
ALTER TABLE Stoppage ADD CHECK (HOUR(Arrival_Time) < 24 AND HOUR(Departure_Time) < 24);

-- Insert Sample Data
INSERT INTO Account VALUES 
('admin', 'admin@1234', 'admin@railway.com', 'Delhi'),
('user101', 'pass123', 'user101@railway.com', 'Mumbai');

INSERT INTO Station VALUES 
('NDLS', 'New Delhi'),
('BLR', 'Bangalore'),
('CNB', 'Kanpur'),
('ALD', 'Allahabad');

INSERT INTO Train VALUES 
(12559, 'Shiv Ganga Exp', 400, 50, 80, 100, 'N', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y');

INSERT INTO Stoppage VALUES 
(12559, 'NDLS', '08:10:00', NULL),
(12559, 'BLR', '19:20:00', '19:30:00');

-- View Available First Class Seats for Trains Arriving Bangalore Before 7 PM on Monday
CREATE VIEW Available_First_Class_Seats AS
SELECT t.Train_No, t.Name, t.Seat_First_Class_AC, s.Arrival_Time 
FROM Train t 
JOIN Stoppage s ON t.Train_No = s.Train_No 
WHERE s.Station_Code = 'BLR' AND HOUR(s.Arrival_Time) < 19 AND t.Run_On_Monday = 'Y';

-- Query to Find Phone Number of a User by Email
SELECT Phone_No 
FROM Contact 
WHERE Username IN (SELECT Username FROM Account WHERE Email_Id = 'admin@railway.com');

-- Trigger to Update Seat Availability on Ticket Cancellation
DELIMITER //
CREATE TRIGGER Ticket_Cancellation 
BEFORE DELETE ON Ticket 
FOR EACH ROW  
BEGIN   
    SET @class = (SELECT Class FROM Passenger WHERE Ticket_No = OLD.Ticket_No);
    
    IF @class = 'First Class AC' THEN    
        UPDATE Train SET Seat_First_Class_AC = Seat_First_Class_AC + 1 WHERE Train_No = OLD.Train_No;   
    ELSEIF @class = 'Sleeper' THEN        
        UPDATE Train SET Seat_Sleeper = Seat_Sleeper + 1 WHERE Train_No = OLD.Train_No;   
    ELSEIF @class = 'Second Class AC' THEN       
        UPDATE Train SET Seat_Second_Class_AC = Seat_Second_Class_AC + 1 WHERE Train_No = OLD.Train_No;    
    ELSEIF @class = 'Third Class AC' THEN        
        UPDATE Train SET Seat_Third_Class_AC = Seat_Third_Class_AC + 1 WHERE Train_No = OLD.Train_No;      
    END IF; 
END;
//
DELIMITER ;

-- Query to Find Last Departure Time from New Delhi
SELECT MAX(Departure_Time) 
FROM Stoppage 
WHERE Station_Code = 'NDLS';
