import firebase_admin
from firebase_admin import credentials, firestore
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

cred = credentials.Certificate("***.json")
firebase_admin.initialize_app(cred)

def get_user_games(user_id):
    db = firestore.client()

    id_state = []

    try:
        user_ref = db.collection('users').document(user_id)
        user_snapshot = user_ref.get()

        if user_snapshot.exists:
            user_data = user_snapshot.to_dict()

            user_games = user_data.get('games', [])
            
            for game in user_games:
                game_id = game.get('gameID')
                state = game.get('state')
                if game_id and state:
                    id_state.append((game_id, state))
                else:
                    print(f"Missing gameID or state for game {game}")
        else:
            print(f"User with ID {user_id} not found.")
    
    except Exception as e:
        print(f"Error getting user data: {e}")
    
    return id_state

def get_all_games_with_tags():
    db = firestore.client()

    id_tags = []

    try:
        games_ref = db.collection('games')
        games_snapshot = games_ref.get()

        for game in games_snapshot:
            game_data = game.to_dict()
            game_id = game_data.get('id')
            game_tags = game_data.get('tags', [])

            if game_id and game_tags:
                id_tags.append((game_id, game_tags))
            else:
                print(f"Missing id or tags for game {game_id}")
    
    except Exception as e:
        print(f"Error getting game data: {e}")

    return id_tags

def recommend_games(user_id, all_games_with_tags, user_games_with_state):
    user_tags = []
    user_game_ids = set()

    for game_id, state in user_games_with_state:
        user_game_ids.add(game_id)
        for game_id_all, tags in all_games_with_tags:
            if game_id == game_id_all and state != "dropped":
                user_tags += tags
                break
    
    all_tags = [", ".join(tags) for _, tags in all_games_with_tags]

    user_tags_str = ", ".join(user_tags)

    all_tags.append(user_tags_str)

    vectorizer = CountVectorizer().fit_transform(all_tags)
    
    cosine_sim = cosine_similarity(vectorizer[-1], vectorizer[:-1])
    
    similar_indices = cosine_sim.argsort()[0][::-1]
    
    recommended_games = []
    
    for idx in similar_indices:
        game_id_all, _ = all_games_with_tags[idx]
        if game_id_all not in user_game_ids:
            recommended_games.append(game_id_all)
                
    # Return 3 ids of 3 most recommended games
    return recommended_games[:3]

def main(user_id):
    user_games_with_state = get_user_games(user_id)
    all_games_with_tags = get_all_games_with_tags()
    recommended_games = recommend_games(user_id, all_games_with_tags, user_games_with_state)
    return recommended_games

if __name__ == "__main__":
    user_id = ""
    print(main(user_id))