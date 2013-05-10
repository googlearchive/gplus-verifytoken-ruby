# Google+ Ruby Token Verification
This sample shows how to verify ID Tokens and Access Tokens sent to your
server. 

## Don't use this, and use the one-time code exchange instead
Before using this technique, consider using the one-time code flow
for getting authorization and authentication information to your server.
The one-time code flow is the best way to send authorization information
from a client application to your server, but it is not available in all
situations. The server-side Quickstarts at
https://developers.google.com/+/quickstart/ all use the one-time code flow.

## Good use cases
* Send ID Token with requests that need to be authenticated.
* Send Access Token to server so that the server can make requests to
  Google APIs, when the one-time code flow is unavailable and the
  server does not already have authorization tokens.

## Security Concerns 
ID Tokens and Access Tokens are sensitive pieces of information. Do not
let attackers intercept these tokens. Send these tokens over HTTPS and
take any other necessary security precautions.

## When to do token verification
All tokens need to be verified unless you know they came directly
from Google. Any tokens from a your client apps, such as an Android app,
iOS app, or website, must be verified.

## Run this sample

TODO: Include instructions.
