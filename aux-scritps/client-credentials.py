# %% [markdown]
# The current python notebook shows an example of How to perform an server-to-server authentication using the Client Credentials flow

# %% [markdown]
# This flow does not include the authorization. So will only be avaiable those endpoints that do not access user information

# %%
import base64
import requests
import boto3
import json

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

credentials = f"{client_id}:{client_secret}"
credentials_base64 = base64.b64encode(credentials.encode()).decode()

# %%
auth_options = {
    'url': 'https://accounts.spotify.com/api/token',
    'headers': {
        'Authorization':'Basic ' + credentials_base64
    },
    'data': {
        'grant_type': 'client_credentials',
        'scope': 'user-read-recently-played'
    },
    'json': True
}

# %%
response = requests.post(**auth_options)

# %%
access_token = response.json().get('access_token')


