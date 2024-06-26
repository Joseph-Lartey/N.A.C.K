import mysql.connector
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from datetime import date

# Calculate age
def calculate_age(dob):
    today = date.today()
    born = date.fromisoformat(dob)
    return today.year - born.year - ((today.month, today.day) < (born.month, born.day))

# Connect the db
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="nack_database"
)

# Fetch details (userId = 1)
cursor = db.cursor(dictionary=True)
cursor.execute("""
SELECT 
    u.userId, 
    u.gender,
    u.dob,
    up.gender_preference,
    up.age_range_min,
    up.age_range_max,
    GROUP_CONCAT(i.interestName SEPARATOR ', ') AS interests
FROM 
    Users u
JOIN 
    UserPreferences up ON u.userId = up.userId
JOIN 
    UserInterests ui ON u.userId = ui.userId
JOIN 
    Interests i ON ui.interestId = i.interestId
WHERE
    u.userId = 1  -- Assuming you are user with userId = 1
GROUP BY 
    u.userId;
""")
user = cursor.fetchone()

# Fetch all other users and their interests
cursor.execute("""
SELECT 
    u.userId, 
    u.gender,
    u.dob,
    up.gender_preference,
    up.age_range_min,
    up.age_range_max,
    GROUP_CONCAT(i.interestName SEPARATOR ', ') AS interests
FROM 
    Users u
JOIN 
    UserPreferences up ON u.userId = up.userId
JOIN 
    UserInterests ui ON u.userId = ui.userId
JOIN 
    Interests i ON ui.interestId = i.interestId
WHERE
    u.userId != 1  -- Exclude the user with userId = 1
GROUP BY 
    u.userId;
""")
users = cursor.fetchall()

# Prepare the data for similarity calculation
user_ids = [user['userId'] for user in users]
interests = [user['interests'] for user in users]

# Add the first user's interests to the list
user_ids.insert(0, user['userId'])
interests.insert(0, user['interests'])

# Vectorize the interests
vectorizer = CountVectorizer().fit_transform(interests)
vectors = vectorizer.toarray()

# Calculate cosine similarity
cosine_sim = cosine_similarity(vectors)

# Threshold for considering a good match
threshold = 0.5

# Insert matches for userId = 1
for idx, other_user in enumerate(users):
    similarity = cosine_sim[0][idx + 1]  # Avoid self-similarity
    if similarity >= threshold:
        cursor.execute("""
            INSERT INTO Matches (userId_1, userId_2, similarity, isMatched)
            VALUES (%s, %s, %s, %s)
        """, (user['userId'], other_user['userId'], similarity, True))

db.commit()

cursor.close()
db.close()
