-- Airline

create database D123;
use D123;

CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    Airline VARCHAR(100),
    Source VARCHAR(100),
    Destination VARCHAR(100),
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    AvailableSeats INT
);

CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    PassportNumber VARCHAR(20) UNIQUE
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    PassengerID INT,
    FlightID INT,
    SeatNumber VARCHAR(10),
    BookingDate DATETIME,
    Status VARCHAR(20) CHECK (Status IN ('Confirmed', 'Cancelled', 'Pending')),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

INSERT INTO Flight VALUES 
(1, 'American Airlines', 'New York', 'Los Angeles', '2025-04-03 10:00:00', '2025-04-03 14:00:00', 5),
(2, 'Delta Airlines', 'New York', 'Los Angeles', '2025-04-03 12:00:00', '2025-04-03 16:00:00', 0),
(3, 'United Airlines', 'Los Angeles', 'Chicago', '2025-04-04 08:00:00', '2025-04-04 11:00:00', 3);

INSERT INTO Passenger VALUES 
(1, 'Alice Johnson', 'alice@example.com', '1234567890', 'P123456'),
(2, 'Bob Smith', 'bob@example.com', '9876543210', 'P654321');

INSERT INTO Booking VALUES 
(1, 1, 1, 'A1', '2025-04-01 09:30:00', 'Confirmed'),
(2, 1, 2, 'B2', '2025-04-01 10:00:00', 'Confirmed'),
(3, 1, 3, 'C3', '2025-04-01 11:00:00', 'Confirmed'),
(4, 1, 1, 'A2', '2025-04-02 08:30:00', 'Confirmed'),
(5, 2, 2, 'B3', '2025-04-02 09:00:00', 'Cancelled');


-- Retrieve Flights from "New York" to "Los Angeles"
SELECT * FROM Flight 
WHERE Source = 'New York' AND Destination = 'Los Angeles';

--  Find Passengers Who Have Booked More Than 3 Flights
SELECT p.PassengerID, p.Name, COUNT(b.BookingID) AS TotalBookings
FROM Booking b
JOIN Passenger p ON b.PassengerID = p.PassengerID
WHERE b.Status = 'Confirmed'
GROUP BY p.PassengerID, p.Name
HAVING COUNT(b.BookingID) > 3;

-- Retrieve Flights Departing Within the Next 24 Hours
SELECT * FROM Flight
WHERE DepartureTime BETWEEN NOW() AND NOW() + INTERVAL 24 HOUR;

-- Display Total Bookings Per Flight
SELECT f.FlightID, f.Airline, COUNT(b.BookingID) AS TotalBookings
FROM Booking b
JOIN Flight f ON b.FlightID = f.FlightID
WHERE b.Status = 'Confirmed'
GROUP BY f.FlightID, f.Airline;

-- Find Flights That Are Fully Booked
SELECT f.FlightID, f.Airline, f.AvailableSeats, COUNT(b.BookingID) AS TotalBookings
FROM Flight f
JOIN Booking b ON f.FlightID = b.FlightID
WHERE b.Status = 'Confirmed'
GROUP BY f.FlightID, f.Airline, f.AvailableSeats
HAVING COUNT(b.BookingID) >= f.AvailableSeats;
