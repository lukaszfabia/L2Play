import firebase_admin
import uuid
from firebase_admin import credentials, firestore


cred = credentials.Certificate("***.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

game_data_list = [
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 59.99,
        "_rating": 4.9,
        "_releaseYear": 2022,
        "description": "A highly anticipated action RPG with breathtaking open-world exploration and intricate combat mechanics.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Elden Ring",
        "pictures": [
            "https://www.cnet.com/a/img/resize/43bf7152f39f90a03df23c97a8a7ebb9a09ea520/hub/2022/02/23/f12a8db7-d99b-4b8d-9b09-d84f12661cf7/elden-ring-plakat.jpg?auto=webp&fit=bounds&height=1200&precrop=571,571,x357,y149&width=1200"
        ],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "FromSoftware",
        "tags": ["Action", "RPG", "Open-World"]
    },
    {
        "_community": 4,
        "_popularity": 5,
        "_price": 49.99,
        "_rating": 4.8,
        "_releaseYear": 2020,
        "description": "An action-packed, mythological open-world adventure featuring a Spartan warrior's journey.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Assassin's Creed Valhalla",
        "pictures": [
            "https://staticctf.ubisoft.com/J3yJr34U2pZ2Ieem48Dwy9uqj5PNUQTn/1bXV4GmkuaDcq7lywSD2Pl/01233a59cd8bab26059747124576cfa6/ac-valhalla-hero-mobile.jpg"
        ],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "Ubisoft",
        "tags": ["Action", "Adventure", "Open-World"]
    },
    {
        "_community": 5,
        "_popularity": 4,
        "_price": 59.99,
        "_rating": 4.6,
        "_releaseYear": 2019,
        "description": "An intense shooter experience with a compelling campaign and robust multiplayer modes.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Call of Duty: Modern Warfare",
        "pictures": [
            "https://static.wikia.nocookie.net/callofduty/images/1/15/ModernWarfare_Artwork_MW.jpg/revision/latest?cb=20190530170954"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Infinity Ward",
        "tags": ["Shooter", "Multiplayer", "Action"]
    },
    {
        "_community": 4,
        "_popularity": 5,
        "_price": 39.99,
        "_rating": 4.7,
        "_releaseYear": 2020,
        "description": "A unique, innovative indie title blending exploration and creative building in a magical setting.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Minecraft Dungeons",
        "pictures": [
            "https://cdn.cdkeys.com/700x700/media/catalog/product/m/i/minecraft_dungeons_ultimate_edition_windows_10_1.jpg"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Mojang Studios",
        "tags": ["Indie", "Adventure", "Multiplayer"]
    },
    {
        "_community": 5,
        "_popularity": 4,
        "_price": 69.99,
        "_rating": 4.9,
        "_releaseYear": 2023,
        "description": "The ultimate racing simulator with unparalleled realism and stunning visuals.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Gran Turismo 7",
        "pictures": [
            "https://image.api.playstation.com/vulcan/ap/rnd/202202/2806/wpHT6JXmOA9iECLZKRPRvt0U.png"
        ],
        "platform": ["PS4", "PS5"],
        "studio": "Polyphony Digital",
        "tags": ["Racing", "Simulator", "Multiplayer"]
    },
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 59.99,
        "_rating": 4.8,
        "_releaseYear": 2017,
        "description": "A groundbreaking open-world action-adventure game set in a post-apocalyptic world dominated by machines.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "The Legend of Zelda: Breath of the Wild",
        "pictures": [
            "https://static.posters.cz/image/750/plotno-the-legend-of-zelda-breath-of-the-wild-view-i111060.jpg"
        ],
        "platform": ["Nintendo Switch", "Wii U"],
        "studio": "Nintendo",
        "tags": ["Action", "Adventure", "Open-World"]
    },
    {
        "_community": 4,
        "_popularity": 4,
        "_price": 39.99,
        "_rating": 4.7,
        "_releaseYear": 2018,
        "description": "A cinematic action-adventure game following Kratos and his son Atreus on a mythological journey.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "God of War",
        "pictures": [
            "https://i.ebayimg.com/thumbs/images/g/OeQAAOSwtEJj-mIp/s-l1200.jpg"
        ],
        "platform": ["PS4", "PS5"],
        "studio": "Santa Monica Studio",
        "tags": ["Action", "Adventure", "Mythology"]
    },
    {
        "_community": 4,
        "_popularity": 5,
        "_price": 49.99,
        "_rating": 4.5,
        "_releaseYear": 2020,
        "description": "A unique blend of farming, dungeon crawling, and character relationships in a charming pixel art world.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Stardew Valley",
        "pictures": [
            "https://store-images.s-microsoft.com/image/apps.44413.65985311967005000.4f51b5e9-febf-4990-8951-33ba59b634c9.924253ef-36b2-4cc0-8bb1-9a97c88d4828"
        ],
        "platform": ["PC", "Nintendo Switch", "Mobile"],
        "studio": "ConcernedApe",
        "tags": ["Indie", "Simulation", "Adventure"]
    },
    {
        "_community": 5,
        "_popularity": 4,
        "_price": 69.99,
        "_rating": 4.9,
        "_releaseYear": 2022,
        "description": "A post-apocalyptic RPG where players explore a vast wasteland filled with challenges and secrets.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Horizon Forbidden West",
        "pictures": [
            "https://image.api.playstation.com/vulcan/ap/rnd/202107/3100/HO8vkO9pfXhwbHi5WHECQJdN.png"
        ],
        "platform": ["PS4", "PS5"],
        "studio": "Guerrilla Games",
        "tags": ["RPG", "Action", "Adventure"]
    },
    {
        "_community": 4,
        "_popularity": 3,
        "_price": 29.99,
        "_rating": 4.4,
        "_releaseYear": 2018,
        "description": "A physics-based multiplayer party game filled with hilarious challenges and chaos.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Human: Fall Flat",
        "pictures": [
            "https://sklepzgrami.pl/wp-content/uploads/2024/06/Human-Fall-Flat.png"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "No Brakes Games",
        "tags": ["Indie", "Multiplayer", "Puzzle"]
    },
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 59.99,
        "_rating": 4.8,
        "_releaseYear": 2020,
        "description": "A dynamic hack-and-slash RPG set in the dark world of Sanctuary, where players face demonic hordes.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Diablo IV",
        "pictures": [
            "https://image.api.playstation.com/vulcan/ap/rnd/202405/3123/21a60345b63762324e97658fce8d3c1fa35dfc3dd9555629.jpg"
        ],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "Blizzard Entertainment",
        "tags": ["RPG", "Action", "Multiplayer"]
    },
    {
        "_community": 4,
        "_popularity": 5,
        "_price": 49.99,
        "_rating": 4.7,
        "_releaseYear": 2021,
        "description": "A sci-fi action RPG where players explore alien planets and uncover the mysteries of the cosmos.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Mass Effect Legendary Edition",
        "pictures": [
            "https://cdn1.epicgames.com/offer/2a535f0e7c754dbe9157bf96adc62d56/EGS_MassEffectLegendaryEdition_BioWare_S2_1200x1600-c8286ed1e08b413e7cbdc190db5a589a"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "BioWare",
        "tags": ["RPG", "Sci-Fi", "Adventure"]
    },
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 69.99,
        "_rating": 4.9,
        "_releaseYear": 2023,
        "description": "The ultimate football simulation game, bringing realism and excitement to every match.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "FIFA 23",
        "pictures": [
            "https://assetsio.gnwcdn.com/co4zw5.jpg?width=1200&height=1200&fit=bounds&quality=70&format=jpg&auto=webp"
        ],
        "platform": ["PC",  "PS5", "Xbox Series X"],
        "studio": "EA Sports",
        "tags": ["Sports", "Multiplayer", "Simulation"]
    },
    {
        "_community": 5,
        "_popularity": 4,
        "_price": 59.99,
        "_rating": 4.6,
        "_releaseYear": 2022,
        "description": "A stunning platforming adventure featuring gorgeous hand-drawn visuals and a heartwarming story.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Ori and the Will of the Wisps",
        "pictures": [
            "https://www.codeguru.hu/img/40000/DIGIWINDOWS10002/DIGIWINDOWS10002.webp"
        ],
        "platform": ["PC", "Nintendo Switch", "Xbox Series X"],
        "studio": "Moon Studios",
        "tags": ["Platformer", "Adventure", "Indie"]
    },
    {
        "_community": 4,
        "_popularity": 4,
        "_price": 59.99,
        "_rating": 4.5,
        "_releaseYear": 2019,
        "description": "A tactical shooter emphasizing teamwork and strategy in tense, realistic combat scenarios.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Tom Clancy's Rainbow Six Siege",
        "pictures": [
            "https://static.muve.pl/uploads/product-cover/0041/7939/cover.jpg"
        ],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "Ubisoft",
        "tags": ["Shooter", "Tactical", "Multiplayer"]
    },
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 59.99,
        "_rating": 4.9,
        "_releaseYear": 2022,
        "description": "An epic tale of vengeance and redemption set in a beautifully reimagined feudal Japan.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Ghost of Tsushima",
        "pictures": [
            "https://cdn1.epicgames.com/offer/6e6aa039c73347b885803de65ac5d3db/EGS_GhostofTsushima_SuckerPunchProductions_S2_1200x1600-e23e02c1d70be7b528dba50860f87d39"
        ],
        "platform": ["PS4", "PS5"],
        "studio": "Sucker Punch Productions",
        "tags": ["Action", "Adventure", "Open-World"]
    },
    {
        "_community": 5,
        "_popularity": 5,
        "_price": 49.99,
        "_rating": 4.8,
        "_releaseYear": 2016,
        "description": "A challenging roguelike action game where players face dynamic dungeons filled with secrets and enemies.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Dark Souls III",
        "pictures": [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy6pQJoSC8uV9yhyCxZzRIlhmy-IZ22m1tBxBhM8VFhjiwdk-1fiWf7OAAvPc56eIugwM&usqp=CAU"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "FromSoftware",
        "tags": ["RPG", "Action", "Challenging"]
    },
    {
        "_community": 4,
        "_popularity": 5,
        "_price": 39.99,
        "_rating": 4.7,
        "_releaseYear": 2019,
        "description": "An exciting co-op looter-shooter with chaotic battles and quirky characters.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Borderlands 3",
        "pictures": [
            "https://cdn1.epicgames.com/catnip/offer/2KGMKT_BL3_UL_ED_EPIC_Portrait_860x1148-860x1148-c040cc358321cd1fb63e6647be0ccb3c.jpg"
        ],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "Gearbox Software",
        "tags": ["Shooter", "Co-op", "RPG"]
    },
    {
        "_community": 4,
        "_popularity": 4,
        "_price": 59.99,
        "_rating": 4.5,
        "_releaseYear": 2018,
        "description": "A post-apocalyptic RPG that challenges players to survive in a world of nuclear devastation.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Fallout 76",
        "pictures": [
            "https://static.muve.pl/uploads/product-cover/0179/9746/fallout-76-okladka-gra-pc-muve.jpg"
        ],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Bethesda Game Studios",
        "tags": ["RPG", "Survival", "Multiplayer"]
    },
    {
        "_community": 5,
        "_popularity": 4,
        "_price": 29.99,
        "_rating": 4.6,
        "_releaseYear": 2020,
        "description": "A creative sandbox game with endless possibilities to build, explore, and survive.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Valheim",
        "pictures": [
            "https://m.media-amazon.com/images/M/MV5BZGE4M2M3M2EtZDhjYi00NjlhLTk1MTQtNTk0YTBmZDYwNTRhXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg"
        ],
        "platform": ["PC"],
        "studio": "Iron Gate Studio",
        "tags": ["Survival", "Multiplayer", "Adventure"]
    },
    {
        "_community": 5,
        "_popularity": 12,
        "_price": 59.99,
        "_rating": 4.7,
        "_releaseYear": 2022,
        "description": "A fast-paced, stylish action game where players battle through a dystopian world with fluid combat.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Bayonetta 3",
        "pictures": ["https://cdn.cdkeys.com/700x700/media/catalog/product/n/e/new_project_-_2023-09-05t104856.867.jpg"],
        "platform": ["Nintendo Switch"],
        "studio": "PlatinumGames",
        "tags": ["Action", "Hack and Slash", "Adventure"]
    },
    {
        "_community": 6,
        "_popularity": 7,
        "_price": 69.99,
        "_rating": 4.9,
        "_releaseYear": 2023,
        "description": "An open-world action-adventure where players can explore the American frontier and engage in thrilling quests.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Red Dead Redemption 2",
        "pictures": ["https://images-cdn.ubuy.ae/63ac1121e7698542000276c4-red-dead-redemption-2-pc-online-game.jpg"],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Rockstar Games",
        "tags": ["Action", "Adventure", "Open-World", "Western"]
    },
    {
        "_community": 7,
        "_popularity": 8,
        "_price": 49.99,
        "_rating": 4.6,
        "_releaseYear": 2021,
        "description": "A critically acclaimed city-building and management simulation game where you build your own empire.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Humankind",
        "pictures": ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa7l9OoZthXXtM3yeZ8b8o-zpsjQqOYLNU7A&s"],
        "platform": ["PC"],
        "studio": "Amplitude Studios",
        "tags": ["Strategy", "Simulation", "City Building"]
    },
    {
        "_community": 8,
        "_popularity": 9,
        "_price": 39.99,
        "_rating": 4.5,
        "_releaseYear": 2020,
        "description": "A survival game set in the depths of the ocean, where players must craft, explore, and survive.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Subnautica",
        "pictures": ["https://upload.wikimedia.org/wikipedia/en/thumb/6/6d/Subnautica_cover_art.png/220px-Subnautica_cover_art.png"],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Unknown Worlds Entertainment",
        "tags": ["Survival", "Adventure", "Open-World"]
    },
    {
        "_community": 9,
        "_popularity": 23,
        "_price": 59.99,
        "_rating": 4.8,
        "_releaseYear": 2022,
        "description": "A gripping horror game set in a terrifying haunted house, full of jump scares and a chilling atmosphere.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "The Medium",
        "pictures": ["https://static.muve.pl/uploads/product-cover/0139/8805/0453986e4a1f3e84c9d3.jpg"],
        "platform": ["PC", "Xbox Series X"],
        "studio": "Bloober Team",
        "tags": ["Horror", "Psychological", "Adventure"]
    },
    {
        "_community": 14,
        "_popularity": 16,
        "_price": 49.99,
        "_rating": 4.6,
        "_releaseYear": 2019,
        "description": "A tactical real-time strategy game that challenges players to outwit and defeat their enemies with complex tactics.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Total War: Three Kingdoms",
        "pictures": ["https://static.muve.pl/uploads/product-cover/0220/8337/total-war-three-kingdoms.JPG"],
        "platform": ["PC"],
        "studio": "Creative Assembly",
        "tags": ["Strategy", "Tactical", "Multiplayer"]
    },
    {
        "_community": 17,
        "_popularity": 19,
        "_price": 29.99,
        "_rating": 4.5,
        "_releaseYear": 2021,
        "description": "A team-based first-person shooter game with a unique cast of heroes and dynamic combat strategies.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "Valorant",
        "pictures": ["https://cdn1.epicgames.com/offer/cbd5b3d310a54b12bf3fe8c41994174f/EGS_VALORANT_RiotGames_S2_1200x1600-7bf61b8b77e394c4bc709f6b02c0db24"],
        "platform": ["PC"],
        "studio": "Riot Games",
        "tags": ["Shooter", "Multiplayer", "Tactical"]
    },
    {
        "_community": 21,
        "_popularity": 24,
        "_price": 39.99,
        "_rating": 4.6,
        "_releaseYear": 2022,
        "description": "A story-driven RPG where players control a team of agents tasked with stopping global threats.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": True,
        "name": "XCOM 2",
        "pictures": ["https://cdn1.epicgames.com/offer/7ec453d446194b8f8afe82aaa9561211/XCOM2_Set_Up_Assets_1200x1600_1200x1600-4b0c6e42af847235877992095e154563_1200x1600-4b0c6e42af847235877992095e154563"],
        "platform": ["PC", "PS4", "Xbox One"],
        "studio": "Firaxis Games",
        "tags": ["RPG", "Strategy", "Sci-Fi"]
    },
    {
        "_community": 31,
        "_popularity": 32,
        "_price": 69.99,
        "_rating": 4.9,
        "_releaseYear": 2022,
        "description": "A visually stunning open-world RPG set in a world inspired by European medieval history.",
        "id": str(uuid.uuid4()).upper(),
        "multiplayerSupport": False,
        "name": "Elden Ring",
        "pictures": ["https://storage.googleapis.com/pod_public/1300/230646.jpg"],
        "platform": ["PC", "PS5", "Xbox Series X"],
        "studio": "FromSoftware",
        "tags": ["Action", "RPG", "Open-World"]
    },
    {
    "_community": 44,
    "_popularity": 22,
    "_price": 39.99,
    "_rating": 4.7,
    "_releaseYear": 2014,
    "description": "A challenging action RPG where players venture through a dark, medieval world, facing tough enemies and epic bosses.",
    "id": str(uuid.uuid4()).upper(),
    "multiplayerSupport": True,
    "name": "Dark Souls II",
    "pictures": ["https://m.media-amazon.com/images/I/71bWcKfZN1L._AC_UF1000,1000_QL80_.jpg"],
    "platform": ["PC", "PS4", "Xbox One"],
    "studio": "FromSoftware",
    "tags": ["Action", "RPG", "Dark Fantasy", "Multiplayer"]
    }
]

def add_game_to_firestore(game_data):
    try:
        db.collection("games").document(game_data["id"]).set(game_data)
        print(f"Game '{game_data['name']}' has been added.")
    except Exception as e:
        print(f"Error: {e}")

def remove_game(game_id):
    try:
        # Odwołanie do kolekcji gier
        games_ref = db.collection("games")
        
        # Znalezienie dokumentu z danym id
        query = games_ref.where("id", "==", game_id).get()
        
        if not query:
            print(f"Game with ID: {game_id} has not been found.")
            return
        
        for doc in query:
            doc.reference.delete()
            print(f"Game with ID: {game_id} has been deleted.")
    
    except Exception as e:
        print(f"Error: {e}")

def update_game_ids(game_data_list):
    for game in game_data_list:
        game['id'] = str(uuid.uuid4())
    return game_data_list

#updated_game_data_list = update_game_ids(game_data_list)

for game_data in game_data_list:
    add_game_to_firestore(game_data)
    #remove_game(game_data.get("id"))