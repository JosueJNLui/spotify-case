# %%
import base64
import requests
import boto3
import json
import pandas as pd
from requests_oauthlib import OAuth2Session
from requests.auth import HTTPBasicAuth

# %%
try: AWS_REGION
except: AWS_REGION='us-east-2'

try:AWS_PROFILE
except: AWS_PROFILE='default'

# %%
session = boto3.Session(profile_name=AWS_PROFILE)
client = session.client('ssm', region_name=AWS_REGION)

# %%
def get_ssm_value(client:str, name: str) -> str:
    
    response = client.get_parameters(
        Names=[name],WithDecryption=True
    )
    for parameter in response['Parameters']:
        return parameter['Value']

# %%
token_url = "https://accounts.spotify.com/api/token"


# %%
client_id = get_ssm_value(client, 'dev-josu-client-id')
client_secret = get_ssm_value(client, 'dev-josu-client-secret')
refresh_token = get_ssm_value(client, 'spotify-refresh-token')

# %%
auth = HTTPBasicAuth(client_id, client_secret)

token_params = {
        "grant_type":   "refresh_token",
        "refresh_token": refresh_token,
    }

# %%
token_response = requests.post(token_url,
                               auth=auth,
                               data=token_params)
token = token_response.json()

# %%
access_token = token.get("access_token")

# %%
recently_played_tracks_endpoint = "https://api.spotify.com/v1/me/player/recently-played"
headers = {
    "Authorization": f"Bearer {access_token}"
    }
response = requests.get(recently_played_tracks_endpoint, headers=headers)

# %%
if response.status_code == 200:
    user_info = response.json()
    print(f"User Info: {user_info}")
    # return {"statusCode": 200, "body": "Success"}
else:
    print(f"Failed to retrieve user info. Status Code: {response.status_code}")
    # return {"statusCode": response.status_code, "body": "Error"}

# %%
song_ids = []
song_names = []
song_links = []

artist_ids = []
artist_names = []
artist_links = []

played_at = []
duration_ms = []

for item in user_info.get("items", []):
    track_info = item.get('track', {})
    artist_info = track_info.get('artists', [])[0]

    song_ids.append(track_info.get('id', ''))
    song_names.append(track_info.get('name', ''))
    song_links.append(track_info.get('external_urls', {}).get('spotify', ''))

    artist_ids.append(artist_info.get('id', ''))
    artist_names.append(artist_info.get('name', ''))
    artist_links.append(artist_info.get('external_urls', {}).get('spotify', ''))

    played_at.append(item.get('played_at', ''))
    duration_ms.append(track_info.get('duration_ms', ''))

df = pd.DataFrame({
    'song_id':       song_ids,
    'name_song':     song_names,
    'song_link':     song_links,
    'artist_id':     artist_ids,
    'artist_name':   artist_names,
    'artist_link':   artist_links,
    'played_at':     played_at,
    'duration_ms':   duration_ms
})