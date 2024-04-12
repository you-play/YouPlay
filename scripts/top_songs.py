from collections import defaultdict
import json
import requests

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

    playlists_with_ids = defaultdict(list)  # playlist_title -> list of song ids
    for playlist_name, songs in playlists.items():
        print(f"Starting search songs inside of '{playlist_name}")

        for song_name in songs:
            print(f"Searching for '{song_name}'")
            track_id = search_spotify_track_id(song_name, bearer_token)

            if track_id:
                playlists_with_ids[playlist_name].append(track_id)

    print(f'Writting results to {output_file_path}')
    with open(output_file_path, 'w') as file:
        json.dump(playlists_with_ids, file, indent=2)


def search_spotify_track_id(song_name: str, bearer_token: str) -> str | None:
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

            if data['tracks']['items']:
                track_id = data['tracks']['items'][0]['id']
                return track_id
        else:
            print(f"ERROR: received a '{response.status_code}' HTTP status code while searching for '{song_name}'")
    except Exception as e:
        print(f"ERROR: unable to find song '{song_name}'", e)

    return None


if __name__ == "__main__":
    main()
