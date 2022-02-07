#!/bin/bash

mix ecto.migrate
exec mix test