import random
import firebase_admin

from faker import Faker
from firebase_admin import credentials
from firebase_admin import firestore

# --------------------------
# FIREBASE
# --------------------------

cred = credentials.Certificate(r"C:\Users\victor\EcoQuest\ecoquest\serviceAccountKey.json")

firebase_admin.initialize_app(cred)

db = firestore.client()

fake = Faker()

houses = [
    "Emerald",
    "Sapphire",
    "Ruby",
    "Gold",
]

avatars = [
    "https://i.pravatar.cc/300?img=1",
    "https://i.pravatar.cc/300?img=2",
    "https://i.pravatar.cc/300?img=3",
    "https://i.pravatar.cc/300?img=4",
    "https://i.pravatar.cc/300?img=5",
    "https://i.pravatar.cc/300?img=6",
    "https://i.pravatar.cc/300?img=7",
    "https://i.pravatar.cc/300?img=8",
    "https://i.pravatar.cc/300?img=9",
    "https://i.pravatar.cc/300?img=10",
]

for i in range(1):

    uid = "victor"

    quests = random.randint(0, 18)

    solo = quests * random.randint(18, 45)

    streak = random.randint(0, 16)

    community = solo + random.randint(0, 200)

    db.collection("users").document(uid).set({

    # Identity
    "uid": uid,
    "username": fake.first_name(),
    "email": fake.email(),
    "photoUrl": random.choice(avatars),

    # School
    "school": "Greensfield High",
    "house": random.choice([
        "Emerald",
        "Ruby",
        "Sapphire",
        "Gold"
    ]),

    # Progress
    "level": random.randint(1, 15),
    "xp": random.randint(100, 5000),

    # Rankings
    "rank": random.choice([
        "Eco Scout",
        "Cleanup Ranger",
        "Nature Guardian",
        "Forest Knight",
        "Eco Champion"
    ]),

    "globalRank": random.randint(1, 150),
    "schoolRank": random.randint(1, 40),

    # Quest Stats
    "soloPoints": random.randint(100, 2500),
    "communityPoints": random.randint(300, 4000),

    "questsCompleted": random.randint(0, 40),
    "activeQuests": random.randint(0, 4),

    "dailyStreak": random.randint(0, 15),

    # Environmental Impact
    "wasteCollectedKg": random.randint(5, 140),
    "treesSaved": random.randint(0, 18),
    "co2ReducedKg": random.randint(8, 420),

    "volunteersInspired": random.randint(1, 80),

    # Achievements

    "badges":[
        "First Quest",
        "Eco Hero",
        "Team Player",
        "7 Day Streak"
    ],

    # Account

    "createdAt": firestore.SERVER_TIMESTAMP
})

print("Finished creating users.")
