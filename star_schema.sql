CREATE DATABASE star_schema;
USE star_schema;
/* Netflix Example From the Assignment */

CREATE TABLE User_Dim (
    User_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Country VARCHAR(30)
);

CREATE TABLE Movie_Dim (
    Movie_ID INT PRIMARY KEY,
    Movie_Name VARCHAR(50),
    Genre VARCHAR(25),
    Language VARCHAR(25)
);

CREATE TABLE Date_Dim (
    Date_ID INT PRIMARY KEY,
    Month VARCHAR(15),
    Year INT
);

CREATE TABLE Watch_Fact (
    Watch_ID INT PRIMARY KEY,
    User_ID INT,
    Movie_ID INT,
    Date_ID INT,
    Watch_Time INT,
    Rating INT,
    foreign key(User_ID) references User_Dim(User_ID),
    foreign key(Movie_ID) references Movie_Dim(Movie_ID),
    foreign key(Date_ID) references Date_Dim(Date_ID)
);

-- 1. Insert Data into User_Dim
INSERT INTO User_Dim (User_ID, Name, Age, Country) VALUES
(1, 'Alice Johnson', 28, 'USA'),
(2, 'Rahul Sharma', 32, 'India'),
(3, 'Carlos Gomez', 24, 'Spain'),
(4, 'Maria Silva', 29, 'Brazil'),
(5, 'John Smith', 45, 'UK'),
(6, 'Priya Patel', 27, 'India'),
(7, 'Yuki Tanaka', 35, 'Japan'),
(8, 'Emma Brown', 22, 'Canada'),
(9, 'Lucas Miller', 40, 'USA'),
(10, 'Sophia Rossi', 31, 'Italy'),
(11, 'Liam Wilson', 26, 'Australia'),
(12, 'Mia Kim', 23, 'South Korea'),
(13, 'Noah Garcia', 38, 'Mexico'),
(14, 'Isabella Martinez', 34, 'Spain'),
(15, 'William Taylor', 50, 'UK'),
(16, 'Aisha Khan', 29, 'UAE'),
(17, 'James Anderson', 41, 'USA'),
(18, 'Charlotte Thomas', 25, 'Canada'),
(19, 'Benjamin Lee', 33, 'Singapore'),
(20, 'Amelia White', 28, 'Australia');

-- 2. Insert Data into Movie_Dim
INSERT INTO Movie_Dim (Movie_ID, Movie_Name, Genre, Language) VALUES
(101, 'Stranger Things', 'Sci-Fi', 'English'),
(102, 'Money Heist', 'Action', 'Spanish'),
(103, 'Squid Game', 'Thriller', 'Korean'),
(104, 'The Crown', 'Drama', 'English'),
(105, 'Dark', 'Sci-Fi', 'German'),
(106, 'Sacred Games', 'Crime', 'Hindi'),
(107, 'Narcos', 'Crime', 'Spanish'),
(108, 'Bridgerton', 'Romance', 'English'),
(109, 'Lupin', 'Mystery', 'French'),
(110, 'The Witcher', 'Fantasy', 'English'),
(111, 'Mirzapur', 'Action', 'Hindi'),
(112, 'Elite', 'Drama', 'Spanish'),
(113, 'Black Mirror', 'Sci-Fi', 'English'),
(114, 'Peaky Blinders', 'Crime', 'English'),
(115, 'Alice in Borderland', 'Thriller', 'Japanese'),
(116, 'Ozark', 'Crime', 'English'),
(117, 'Delhi Crime', 'Crime', 'Hindi'),
(118, 'The Queen''s Gambit', 'Drama', 'English'),
(119, 'Vincenzo', 'Comedy', 'Korean'),
(120, 'Top Boy', 'Crime', 'English');

-- 3. Insert Data into Date_Dim
INSERT INTO Date_Dim (Date_ID, Month, Year) VALUES
(201, 'January', 2023),
(202, 'February', 2023),
(203, 'March', 2023),
(204, 'April', 2023),
(205, 'May', 2023),
(206, 'June', 2023),
(207, 'July', 2023),
(208, 'August', 2023),
(209, 'September', 2023),
(210, 'October', 2023),
(211, 'November', 2023),
(212, 'December', 2023),
(213, 'January', 2024),
(214, 'February', 2024),
(215, 'March', 2024),
(216, 'April', 2024),
(217, 'May', 2024),
(218, 'June', 2024),
(219, 'July', 2024),
(220, 'August', 2024);

-- 4. Insert Data into Watch_Fact
INSERT INTO Watch_Fact (Watch_ID, User_ID, Movie_ID, Date_ID, Watch_Time, Rating) VALUES
(1001, 1, 101, 201, 120, 5),
(1002, 2, 106, 202, 90, 4),
(1003, 3, 102, 201, 150, 5),
(1004, 4, 102, 203, 60, 3),
(1005, 5, 104, 205, 180, 4),
(1006, 12, 103, 208, 200, 5),
(1007, 7, 115, 210, 110, 4),
(1008, 6, 111, 212, 95, 5),
(1009, 8, 108, 213, 140, 4),
(1010, 9, 116, 214, 170, 5),
(1011, 10, 109, 215, 100, 3),
(1012, 1, 113, 216, 80, 4),
(1013, 2, 117, 217, 130, 5),
(1014, 15, 114, 218, 160, 5),
(1015, 14, 107, 219, 125, 4),
(1016, 11, 110, 220, 145, 3),
(1017, 18, 118, 207, 190, 5),
(1018, 19, 103, 209, 210, 5),
(1019, 20, 101, 211, 115, 4),
(1020, 3, 112, 204, 85, 3);

SELECT * FROM Watch_Fact;
SELECT * FROM User_Dim;
SELECT * FROM Movie_Dim;
SELECT * FROM Date_Dim;

-- Tasks:
-- 1.	Identify Grain:
/*
	One Show Watched by an user on specific date
*/
-- 2.	Identify Measures:
/* Watch_Time
   Rating
*/
-- 3.	Draw Star Schema:
/*
				User_Dim
					|
					|
Movie_Dim -- -- Watch_Fact  -- -- Date_Dim
*/
-- 4.	Write SQL queries: 
-- Total watch time:

SELECT SUM(Watch_Time) as Total_Watch_Time
FROM Watch_Fact;
 
-- Top movies:

SELECT m.Movie_Name, SUM(w.Watch_Time) AS Total_Watch_Time, ROUND(AVG(w.Rating), 2) As Avg_Rating
FROM Movie_Dim as m
JOIN Watch_Fact as w ON m.Movie_ID = w.Movie_ID
GROUP BY m.Movie_Name
ORDER BY Avg_Rating DESC
LIMIT 1;
 
-- Monthly viewers: 

SELECT d.Year, d.Month, COUNT(DISTINCT w.User_ID) AS Unique_Monthly_Viewers
FROM Date_Dim as d JOIN Watch_Fact as w
ON d.Date_ID = w.Date_ID
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;


