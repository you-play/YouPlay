from collections import defaultdict
import json
import requests
import random

'''
Retrieves the Spotify track IDs from a JSON file of playlists.
Make sure to provide an 'bearer_token`.

Input JSON must be as follows:
{
    "Playlist 1": [
        "Title1",
        "Title 2",
        ...
    ],
    ...
}
'''
def main():
    bearer_token = 'REPLACE ME'
    input_file_path = 'playlists.json'
    output_file_path = 'playlists-with-song-ids.json'

    playlists = {}  # playlist_title -> [song names]
    with open(input_file_path, 'r') as file:
        playlists = json.load(file)

    playlists_with_ids = [] # playlist_name -> {songs: [list of songs], imageUrl}
    for playlist_name, songs in playlists.items():
        print(f"Starting search songs inside of '{playlist_name}")
        playlist = {
            'title': playlist_name,
            'songIds': [],
            'imageUrl': ''
        }

        for song_name in songs:
            print(f"Searching for '{song_name}'")
            song_metadata = get_spotify_song_metadata(song_name, bearer_token)

            if song_metadata:
                song_id = song_metadata['id']
                playlist['songIds'].append(song_id)

        # assign an imageUrl randomly from one of the songs
        print(f"Assigning imageUrl to '{playlist_name}'")
        song_id = random.choice(playlist['songIds'])

        if song_id:
            playlist['imageUrl'] = get_image_url_from_track_title(song_id, bearer_token)
        else: 
            # stock image
            playlist['imageUrl'] = 'https://community.spotify.com/t5/image/serverpage/image-id/25294i2836BD1C1A31BDF2?v=v2'
        
        playlists_with_ids.append(playlist)

    print(f'Writing results to {output_file_path}')
    with open(output_file_path, 'w') as file:
        json.dump(playlists_with_ids, file, indent=2)


def get_spotify_song_metadata(song_name, bearer_token):
    endpoint = "https://api.spotify.com/v1/search"
    params = {
        "q": song_name, 
        "type": "track"
    }
    headers = {
        "Authorization": "Bearer " + bearer_token
    }

    try:
        response = requests.get(endpoint, params=params, headers=headers)

        if response.status_code == 200:
            data = response.json()

            if data:
                song_metadata = data['tracks']['items'][0]
                return song_metadata
        else:
            print(f"ERROR: received a '{response.status_code}' HTTP status code while searching for '{song_name}'")
    except Exception as e:
        print(f"ERROR: unable to find song '{song_name}'", e)

    return None

def get_image_url_from_track_title(track_id, bearer_token):
    endpoint = f"https://api.spotify.com/v1/tracks/{track_id}"
    headers = {
        "Authorization": "Bearer " + bearer_token
    }

    try:
        response = requests.get(endpoint, headers=headers)

        if response.status_code == 200:
            data = response.json()

            if data:
                imageUrl = data['album']['images'][0]['url']
                return imageUrl
        else:
            print(f"ERROR: received a '{response.status_code}' HTTP status code while getting image for track_id '{track_id}'")
    except Exception as e:
        print(f"ERROR: unable to find image for track_id '{track_id}'", e)

    return None

if __name__ == "__main__":
    main()
