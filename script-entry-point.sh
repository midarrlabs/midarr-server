#!/bin/bash

mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server