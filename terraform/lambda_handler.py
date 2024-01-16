
import base64
import requests
import boto3
import json
from datetime import datetime
import pandas as pd
from requests_oauthlib import OAuth2Session
from requests.auth import HTTPBasicAuth
import hashlib
from io import BytesIO
import os
import time
import sys


def print_time_range(start_time):

    end_time = time.strftime("%X", time.gmtime(time.time()))
    print("Start time:\n",
          start_time,
          "End time",
          end_time)


def get_ssm_value(ssm_client:str, name: str) -> str:
    
    response = ssm_client.get_parameters(
        Names=[name],WithDecryption=True
    )
    for parameter in response['Parameters']:
        return parameter['Value']


def get_access_token(client_id:str, client_secret:str, refresh_token:str):

    token_url = "https://accounts.spotify.com/api/token"
    auth = HTTPBasicAuth(client_id, client_secret)
    
    token_params = {
        "grant_type":   "refresh_token",
        "refresh_token": refresh_token,
    }
    
    token_response = requests.post(token_url,
                                   auth=auth,
                                   data=token_params)
    token = token_response.json()
    access_token = token.get("access_token")

    return access_token


def get_recently_played_songs(access_token:str):
    
    recently_played_tracks_endpoint = "https://api.spotify.com/v1/me/player/recently-played"
    headers = {
    "Authorization": f"Bearer {access_token}"
    }
    
    response = requests.get(recently_played_tracks_endpoint, headers=headers)

    return response


def extract_desired_data(user_info:json):
    
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

    return df


def str_to_hash_md5(s:str):

    hash_object = hashlib.md5(s.encode())
    hex_digest = hash_object.hexdigest()

    return hex_digest


def data_processing(df:pd.DataFrame):

    df['created_at'] = datetime.now().replace(second=0, microsecond=0)
    df['col_aux'] = df['played_at'].astype(str) + df['song_id'].astype(str)
    df['hash_md5'] = df['col_aux'].apply(str_to_hash_md5)

    df.drop(columns='col_aux', inplace=True)

    return df


def dataframe_to_parquet_s3(s3_client:str, df:pd.DataFrame, bucket_name:str, key_path):

    filename = "%s%s" % ('data_from_', str(datetime.now().replace(second=0, microsecond=0)))

    out_buffer = BytesIO()
    df.to_parquet(out_buffer, index=False)
    s3_client.put_object(Bucket=bucket_name, Key=str(key_path+filename+'.parquet'), Body=out_buffer.getvalue())

    
def lambda_handler(event, context):

    start_time = time.strftime("%X", time.gmtime(time.time()))
    print(f"Start time:\n",
          start_time)

    # aws_region = sys.argv[1]
    # account_id = sys.argv[2]
    # exec_env = sys.argv[3]

    aws_region = os.environ['AWS_REGION']
    account_id = os.environ['ACCOUNT_ID']
    exec_env = os.environ['EXEC_ENV']

    print(f"AWS Region:\n",
          aws_region)
    
    print(f"ACCOUNT_ID:\n",
          account_id)
    
    print(f"Execution environment:\n",
          exec_env)

    session = boto3.Session(region_name=aws_region)
    ssm_client = session.client('ssm')
    s3_client = session.client('s3')

    client_id = get_ssm_value(ssm_client, 'dev-josu-client-id')
    client_secret = get_ssm_value(ssm_client, 'dev-josu-client-secret')
    refresh_token = get_ssm_value(ssm_client, 'spotify-refresh-token')

    access_token = get_access_token(client_id, client_secret, refresh_token)

    response = get_recently_played_songs(access_token)

    if response.status_code == 200:
        user_info = response.json()
        print(f"User Info:\n", user_info)

        df = extract_desired_data(user_info)
        df = data_processing(df)
        print(f"Dataframe:\n", df)

        bucket_name = "%s%s%s%s%s%s" % ("spotify-case-", aws_region, "-", account_id, "-", exec_env)
        key_path = "recently-played-songs/"

        try:
            dataframe_to_parquet_s3(s3_client, df, bucket_name, key_path)
            print_time_range(start_time)
            return {"statusCode": 200, "body": "Success"}
        except Exception as e:
            print("error", str(e))
            print_time_range(start_time)
    else:
        print(f"Failed to retrieve user info. Status Code: {response.status_code}")
        return {"statusCode": response.status_code, "body": "Error"}
