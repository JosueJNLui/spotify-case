# %% [markdown]
# As the project needs to get user information, It is suitable performing an Authorization Code Flows where the user grants permission only once

# %% [markdown]
# The current script will take the Authorization Code to obtain the Refresh Token which will be necessary when executing the main script on AWS Lambda Service

# %%
import boto3
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
client_id = get_ssm_value(client, 'dev-josu-client-id')
client_secret = get_ssm_value(client, 'dev-josu-client-secret')

# %%
redirect_uri = "https://localhost:8888/callback"
scope = "user-read-recently-played"

# %%
authorization_base_url = "https://accounts.spotify.com/authorize"
token_url = "https://accounts.spotify.com/api/token"

# %%
spotify = OAuth2Session(client_id, scope=scope, redirect_uri=redirect_uri)

# %%
authorization_url, state = spotify.authorization_url(authorization_base_url)

# %%
print(f"Please, access the following link and then authorize it:\n", authorization_url)

# %%
redirect_response = input("Please, paste the full URL here:")

# %%
auth = HTTPBasicAuth(client_id, client_secret)

# %%
token = spotify.fetch_token(token_url,
                            auth=auth,
                            authorization_response=redirect_response)

# %%
refresh_token = token['refresh_token']


