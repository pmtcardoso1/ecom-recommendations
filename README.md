# Ecomrecommendations

## Before starting:

* Install docker https://docs.docker.com/engine/install/
* Install elixir: https://rajrajhans.com/2022/10/installing-elixir-on-mac-m1/
* Install phoenix:
    * `mix local.hex`
    * `mix archive.install github hexpm/hex branch latest` (if running on mac with m1)
    * `mix archive.install hex phx_new`
* Install/run https://github.com/postgresml/postgresml
    * Open localhost:8000
* Install datagrip (database client) (postgresml must be running)
    * local setup:
        * host: localhost
        * post: 5433
        * database: ecomrecommendations_dev

Before starting the development server:

  * Run `mix ecto.create` → creates db
  * Run `mix ecto.migrate` → runs db migrations

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
