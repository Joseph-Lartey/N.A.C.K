DROP DATABASE IF EXISTS nack_database;
CREATE DATABASE nack_database;
USE nack_database;

-- Create Users Table
CREATE TABLE Users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    username VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    phoneNumber VARCHAR(255) UNIQUE,
    gender VARCHAR(50),
    dob DATE,
    bio TEXT,
    profile_Image VARCHAR(255),
    verified BOOLEAN DEFAULT FALSE
);

-- Create User Preferences Table
CREATE TABLE UserPreferences (
    preferenceId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    gender_preference VARCHAR(50),
    age_range_min INT,
    age_range_max INT,
    distance_preference INT,
    FOREIGN KEY (userId) REFERENCES Users(userId)
);

-- Create Matches Table
CREATE TABLE Matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    userId_1 INT,
    userId_2 INT,
    isMatched BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (userId_1) REFERENCES Users(userId),
    FOREIGN KEY (userId_2) REFERENCES Users(userId)
);

-- Create Messages Table
CREATE TABLE Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT,
    sender_id INT,
    message_text TEXT,
    message_audio VARCHAR(255),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (sender_id) REFERENCES Users(userId)
);

-- Create Interests Table
CREATE TABLE Interests (
    interestId INT AUTO_INCREMENT PRIMARY KEY,
    interestName VARCHAR(255) UNIQUE
);

-- Create User Interests Table
CREATE TABLE UserInterests (
    userInterestId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    interestId INT,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (interestId) REFERENCES Interests(interestId)
);

-- Create Blocked Users Table
CREATE TABLE BlockedUsers (
    block_id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    blocked_userId INT,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (blocked_userId) REFERENCES Users(userId)
);

-- Create Reported Users Table
CREATE TABLE ReportedUsers (
    reportId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    reported_userId INT,
    reason TEXT,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (reported_userId) REFERENCES Users(userId)
);

-- Create Push Notifications Table
CREATE TABLE PushNotifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT,
    `read` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES Users(userId)
);

-- Create Consent Contracts Table
CREATE TABLE ConsentContracts (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    userId1 INT,
    userId2 INT,
    consent_text TEXT,
    accepted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId1) REFERENCES Users(userId),
    FOREIGN KEY (userId2) REFERENCES Users(userId)
);

-- Insert Sample Data into Users Table
INSERT INTO Users (name, firstName, lastName, username, email, password, phoneNumber, gender, dob, bio, profile_Image, verified) VALUES
('John Doe', 'John', 'Doe', 'johndoe', 'johndoe@example.com', 'password123', '1234567890', 'Male', '1990-01-01', 'This is John''s bio', 'profile1.jpg', TRUE),
('Jane Smith', 'Jane', 'Smith', 'janesmith', 'janesmith@example.com', 'password123', '0987654321', 'Female', '1992-02-02', 'This is Jane''s bio', 'profile2.jpg', FALSE);

-- Insert Sample Data into User Preferences Table
INSERT INTO UserPreferences (userId, gender_preference, age_range_min, age_range_max, distance_preference) VALUES
(1, 'Female', 25, 35, 50),
(2, 'Male', 28, 38, 30);

-- Insert Sample Data into Interests Table
INSERT INTO Interests (interestName) VALUES
('Reading'),
('Traveling'),
('Music');

-- Insert Sample Data into User Interests Table
INSERT INTO UserInterests (userId, interestId) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3);

-- Insert Sample Data into Matches Table
INSERT INTO Matches (userId_1, userId_2, isMatched) VALUES
(1, 2, TRUE);

-- Insert Sample Data into Messages Table
INSERT INTO Messages (match_id, sender_id, message_text, message_audio) VALUES
(1, 1, 'Hello Jane!', 'audio1.mp3'),
(1, 2, 'Hi John!', 'audio2.mp3');

-- Insert Sample Data into Blocked Users Table
INSERT INTO BlockedUsers (userId, blocked_userId) VALUES
(1, 2);

-- Insert Sample Data into Reported Users Table
INSERT INTO ReportedUsers (userId, reported_userId, reason) VALUES
(2, 1, 'Inappropriate behavior');

-- Insert Sample Data into Push Notifications Table
INSERT INTO PushNotifications (user_id, message, `read`) VALUES
(1, 'You have a new match!', FALSE),
(2, 'New message received!', TRUE);

-- Insert Sample Data into Consent Contracts Table
INSERT INTO ConsentContracts (userId1, userId2, consent_text, accepted) VALUES
(1, 2, 'I consent to share my contact details.', TRUE);


-- 1. Retrieve all users
-- SELECT * FROM Users;

-- 2. Get user preferences for a specific user (e.g., userId = 1)
-- SELECT * FROM UserPreferences WHERE userId = 1;

-- 3. List all users who have been blocked by a specific user (e.g., userId = 1)
-- SELECT Users.userId, Users.name, Users.username
-- FROM BlockedUsers
-- JOIN Users ON BlockedUsers.blocked_userId = Users.userId
-- WHERE BlockedUsers.userId = 1;

-- 4. Find all interests for a specific user (e.g., userId = 2)
-- SELECT Interests.interestName
-- FROM UserInterests
-- JOIN Interests ON UserInterests.interestId = Interests.interestId
-- WHERE UserInterests.userId = 2;

-- 5. Get all messages in a specific match (e.g., match_id = 1)
-- SELECT Messages.message_text, Messages.message_audio, Users.username AS sender
-- FROM Messages
-- JOIN Users ON Messages.sender_id = Users.userId
-- WHERE Messages.match_id = 1;
