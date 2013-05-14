# Google+ Ruby Token Verification
This sample shows how to verify ID tokens and access tokens that are sent to
your server.

## Don't use this, and use the one-time code exchange instead
This technique has potential problems. If possible, you should use the
one-time-code flow for enabling your server to have offline access to
the Google APIs on behalf of the user.
The server-side Quickstarts at
https://developers.google.com/+/quickstart/ all use the one-time-code flow.

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
