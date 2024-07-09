DROP DATABASE IF EXISTS nack_database;
CREATE DATABASE nack_database;
USE nack_database;

-- Create Users Table
CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(35),
    lastName VARCHAR(70),
    username VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    password VARCHAR(60),
    gender VARCHAR(50),
    dob DATE,
    bio TEXT,
    profileImage VARCHAR(255),
    verified BOOLEAN DEFAULT FALSE
);

-- Create User Preferences Table
CREATE TABLE userPreferences (
    preferenceId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    genderPreference VARCHAR(50),
    ageRangeMin INT,
    ageRangeMax INT,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- Create Matches Table
CREATE TABLE matches (
    matchId INT AUTO_INCREMENT PRIMARY KEY,
    userId1 INT,
    userId2 INT,
    FOREIGN KEY (userId1) REFERENCES users(userId),
    FOREIGN KEY (userId2) REFERENCES users(userId)
);

-- Create Tokens Table
CREATE TABLE tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    token VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(userId)
);


-- Create Messages Table
CREATE TABLE messages (
    messageId INT AUTO_INCREMENT PRIMARY KEY,
    matchId INT,
    senderId INT,
    messageText TEXT,
    messageAudio VARCHAR(255),
    FOREIGN KEY (matchId) REFERENCES users(userId),
    FOREIGN KEY (senderId) REFERENCES users(userId)
);

-- Create Interests Table
CREATE TABLE interests (
    interestId INT AUTO_INCREMENT PRIMARY KEY,
    interestName VARCHAR(70) UNIQUE
);

-- Insert interests into the Interests Table
INSERT INTO interests (interestName) VALUES
('Photography'),
('Shopping'),
('Karaoke'),
('Yoga'),
('Cooking'),
('Tennis'),
('Run'),
('Swimming'),
('Art'),
('Traveling'),
('Extreme'),
('Music'),
('Drink'),
('Video games');

-- Create User Interests Table
CREATE TABLE userInterests (
    userInterestId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    interestId INT,
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (interestId) REFERENCES interests(interestId)
);

-- Create Blocked Users Table
CREATE TABLE blockedUsers (
    blockId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    blockedUserId INT,
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (blockedUserId) REFERENCES users(userId)
);

-- Create Reported Users Table
CREATE TABLE reportedUsers (
    reportId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    reportedUserId INT,
    reason TEXT,
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (reportedUserId) REFERENCES users(userId)
);

-- Create Push Notifications Table
CREATE TABLE pushNotifications (
    notificationId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    message TEXT,
    `read` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- Create Consent Contracts Table
CREATE TABLE consentContracts (
    consentId INT AUTO_INCREMENT PRIMARY KEY,
    userId1 INT,
    userId2 INT,
    consentText TEXT,
    accepted BOOLEAN DEFAULT FALSE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId1) REFERENCES users(userId),
    FOREIGN KEY (userId2) REFERENCES users(userId)
);

-- Create Likes Table
CREATE TABLE likes (
    likeId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    likedUserId INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (likedUserId) REFERENCES users(userId)
);

-- Sample Queries:

-- 1. Retrieve all users
-- SELECT * FROM users;

-- 2. Get user preferences for a specific user (e.g., userId = 1)
-- SELECT * FROM userPreferences WHERE userId = 1;

-- 3. List all users who have been blocked by a specific user (e.g., userId = 1)
-- SELECT users.userId, users.firstName, users.lastName, users.username
-- FROM blockedUsers
-- JOIN users ON blockedUsers.blockedUserId = users.userId
-- WHERE blockedUsers.userId = 1;

-- 4. Find all interests for a specific user (e.g., userId = 2)
-- SELECT interests.interestName
-- FROM userInterests
-- JOIN interests ON userInterests.interestId = interests.interestId
-- WHERE userInterests.userId = 2;

-- 5. Get all messages in a specific match (e.g., matchId = 1)
-- SELECT messages.messageText, messages.messageAudio, users.username AS sender
-- FROM messages
-- JOIN users ON messages.senderId = users.userId
-- WHERE messages.matchId = 1;
