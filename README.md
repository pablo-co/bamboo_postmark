# Bamboo.PostmarkAdapter

[![CircleCI](https://circleci.com/gh/pablo-co/bamboo_postmark.svg?style=svg)](https://circleci.com/gh/pablo-co/bamboo_postmark)
[![Module Version](https://img.shields.io/hexpm/v/bamboo_postmark.svg)](https://hex.pm/packages/bamboo_postmark)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/bamboo_postmark/)
[![Total Download](https://img.shields.io/hexpm/dt/bamboo_postmark.svg)](https://hex.pm/packages/bamboo_postmark)
[![License](https://img.shields.io/hexpm/l/bamboo_postmark.svg)](https://github.com/pablo-co/bamboo_postmark/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/pablo-co/bamboo_postmark.svg)](https://github.com/pablo-co/bamboo_postmark/commits/master)

A [Postmark](https://postmarkapp.com/) adapter for the [Bamboo](https://github.com/thoughtbot/bamboo) email library.

## Installation

The package can be installed by adding `:bamboo_postmark` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  # Get from hex
  [
    {:bamboo_postmark, "~> 1.0"}
  ]

  # Or use the latest from master
  [
    {:bamboo_postmark, github: "pablo-co/bamboo_postmark"}
  ]
end
```

Add your Postmark API key to your config. You can find this key as `Server API
token` under the `Credentials` tab in each Postmark server.

```elixir
# In your configuration file:
#  * General configuration: config/config.exs
#  * Recommended production only: config/prod.exs

config :my_app, MyApp.Mailer,
      adapter: Bamboo.PostmarkAdapter,
      api_key: "my_api_key"
      # Or if you want to use an ENV variable:
      # api_key: {:system, "POSTMARK_API_KEY"}
```

Follow Bamboo [Getting Started Guide](https://github.com/thoughtbot/bamboo#getting-started).

## Using templates

The Postmark adapter provides a helper module for setting the template of an
email.

```elixir
defmodule MyApp.Mail do
  import Bamboo.PostmarkHelper

  def some_email do
    email
    |> template("id_of_template",
                %{name: "John Doe", confirm_link: "http://www.link.com"})
  end
end
```

#### Exception Warning

Postmark templates include a subject, HTML body and text body and thus these shouldn't be included in the email as they will raise an API exception.

```elixir
email
|> template("id", %{value: "Some value"})
|> subject("Will raise exception")
|> html_body("<p>Will raise exception</p>")
|> text_body("Will raise exception")
```

## Tagging emails

The Postmark adapter provides a helper module for tagging emails.

```elixir
defmodule MyApp.Mail do
  import Bamboo.PostmarkHelper

  def some_email do
    email
    |> tag("some-tag")
  end
end
```

## Sending extra parameters

You can send other extra parameters to Postmark with the `put_param` helper.

See Postmark's API for a complete list of parameters supported.

```elixir
email
|> put_param("TrackLinks", "HtmlAndText")
|> put_param("TrackOpens", true)
|> put_param("Attachments", [
  %{
    Name: "file.txt",
    Content: "/some/file.txt" |> File.read!() |> Base.encode64(),
    ContentType: "txt"
  }
])
```

## Changing the underlying request configuration

You can specify the options that are passed to the underlying HTTP client
[hackney](https://github.com/benoitc/hackney) by using the `request_options` key
in the configuration.

### Example

```elixir
config :my_app, MyApp.Mailer,
      adapter: Bamboo.PostmarkAdapter,
      api_key: "my_api_key",
      request_options: [recv_timeout: 10_000]
```

## JSON support

Bamboo comes with JSON support out of the box, see [Bamboo JSON support](https://github.com/thoughtbot/bamboo#json-support).

## Copyright and License

Copyright (c) 2016 Pablo Cárdenas

This library is released under the MIT License. See the [LICENSE.md](./LICENSE.md) file.
