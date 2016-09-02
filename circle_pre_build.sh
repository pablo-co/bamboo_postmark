#!/bin/bash

# Ensure exit codes other than 0 fail the build
set -e

# Check for asdf
if ! asdf | grep version; then
  git clone https://github.com/HashNuke/asdf.git ~/.asdf;
fi

# Add plugins for asdf
if ! asdf plugin-list | grep erlang; then
  asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
fi

if ! asdf plugin-list | grep elixir; then
  asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git
fi

# Extract vars from elixir_buildpack.config
. elixir_buildpack.config

# Write .tool-versions
echo "erlang $erlang_version" >> .tool-versions
echo "elixir $elixir_version" >> .tool-versions

# Install erlang/elixir
asdf install erlang $erlang_version
asdf install elixir $elixir_version

# Get dependencies
yes | mix deps.get
yes | mix local.rebar

# Exit successfully
exit 0
