# nerds-n-company

This repo contains technical task provided by Nerds&amp;Company.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup` or run these one by one`ecto.create, ecto.migrate, run priv/repo/seeds.exs`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/oauth/applications`](http://localhost:4000//oauth/applications) from your browser.

- Login with `testuser@example.com` / `secret1234`.
- Create a new application with `urn:ietf:wg:oauth:2.0:oob` as Redirect URI
- Save the application, and take note of of the `ID` and `Secret`.
- Click Authorize next to the Redirect URI, authorize yourself and copy the access grant shown.
- Now we got everything to generate the access token. Replace `CLIENT_ID`, `CLIENT_SECRET` and `AUTHORIZATION_CODE` in the following curl command, and run it:

- curl -X POST "http://localhost:4000/oauth/token?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=urn:ietf:wg:oauth:2.0:oob"
- You’ll receive an access token along with other details. Copy the access token, and use it for to retrieve a resource:

- `curl http://localhost:4000/api/v1/accounts/ \ -H "Authorization: Bearer ACCESS_TOKEN"`
  You’ll get response which will contain data about `ACCESS_TOKEN`
