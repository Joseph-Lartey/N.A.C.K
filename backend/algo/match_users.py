# match_users.py
import mysql.connector
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from datetime import date
import sys

def calculate_age(dob):
    today = date.today()
    born = date.fromisoformat(dob)
    return today.year - born.year - ((today.month, today.day) < (born.month, born.day))

# Get user ID from command line arguments
if len(sys.argv) != 2:
    print("Usage: python match_users.py <userId>")
    sys.exit(1)

user_id = int(sys.argv[1])

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="nack_database"
)

cursor = db.cursor(dictionary=True)
cursor.execute(f"""
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
    u.userId = {user_id}
GROUP BY 
    u.userId;
""")
user = cursor.fetchone()

cursor.execute(f"""
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
    u.userId != {user_id}
GROUP BY 
    u.userId;
""")
users = cursor.fetchall()

user_ids = [user['userId'] for user in users]
interests = [user['interests'] for user in users]

user_ids.insert(0, user['userId'])
interests.insert(0, user['interests'])

vectorizer = CountVectorizer().fit_transform(interests)
vectors = vectorizer.toarray()

cosine_sim = cosine_similarity(vectors)

threshold = 0.3

for idx, other_user in enumerate(users):
    similarity = cosine_sim[0][idx + 1]
    if similarity >= threshold:
        cursor.execute("""
            INSERT INTO Matches (userId_1, userId_2, similarity, isMatched)
            VALUES (%s, %s, %s, %s)
        """, (user['userId'], other_user['userId'], similarity, True))

db.commit()

cursor.close()
db.close()
