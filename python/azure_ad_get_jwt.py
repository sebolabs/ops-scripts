#!/usr/local/bin/python3.7

import sys
import adal
import jwt
import json

# -- CONFIG ----------------------------------------------------------------------------------------

azure_ad_directory_id  = '3c448d90-4ca1-9999-ab59-1a2aa67d7801'
azure_ad_res_client_id = '19fdd68c-4f2f-0000-be55-dd98124d4f74'

users_credentials = {
  "user1": {
    "username": "user1@company.onmicrosoft.com",
    "password": "XXXyyy824571"
  },
  "user2": {
    "username": "user2@company.onmicrosoft.com",
    "password": "YYYzzz540921"
  }
}

# -- INPUT CHECK -----------------------------------------------------------------------------------

if len(sys.argv) == 1:
  exc = "[ERROR] No username provided!\nUsage: {} user1".format(str(sys.argv[0]))
  raise Exception(exc)

user = str(sys.argv[1])

print('USER:', user)

if user not in users_credentials:
  exc = "[ERROR] No config for user '{}'!".format(user)
  raise Exception(exc)

# -- GET JWT ---------------------------------------------------------------------------------------

authority_url = 'https://login.microsoftonline.com/{}'.format(azure_ad_directory_id)

context = adal.AuthenticationContext(
  authority_url,
  validate_authority = True,
  api_version        = None
)

token = context.acquire_token_with_username_password(
  resource  = azure_ad_res_client_id,
  username  = users_credentials[user]["username"],
  password  = users_credentials[user]["password"],
  client_id = azure_ad_res_client_id
)
access_token = token['accessToken']

print("\nACCESS TOKEN:\n", access_token)
print("\nJWT PAYLOAD:\n", json.dumps(jwt.decode(access_token, verify=False), sort_keys=False, indent=4))
print('\nENJOY!')
