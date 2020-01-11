# Tracker

To start Redis:

  * Start redis container `docker-compose up redis`

To start Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Develop

To start tests:

  * Start tests `mix test`
  * Start tests with coverage `MIX_ENV=test mix coveralls`
  * Start tests with coverage html report `MIX_ENV=test mix coveralls.html`
