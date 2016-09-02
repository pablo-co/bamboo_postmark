# Bamboo.PostMarkAdapter

A [Postmark](https://postmarkapp.com/) Adapter for the [Bamboo](https://github.com/thoughtbot/bamboo) email library.

## Installation

The package can be installed as:

  1. Add bamboo_postmark to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      # Get from hex
      [{:bamboo_postmark, "~> 0.1.0"}]
      # Or use the latest from master
      [{:bamboo_postmark, github: "pablo-co/bamboo_postmark"}]
    end
    ```

  2. Ensure bamboo is started before your application:

    ```elixir
    def application do
      [applications: [:bamboo]]
    end
    ```

  3. Add your Postmark API key to your config

    > You can find this key as `Server API token` under the `Credentials` tab in each Postmark server.

    ```elixir
    # In your configuration file:
    #  * General configuration: config/config.exs
    #  * Recommended production only: config/prod.exs

    config :my_app, MyApp.Mailer,
          adapter: Bamboo.PostmarkAdapter
          api_key: "my_api_key"
    ```

  4. Follow Bamboo [Getting Started Guide](https://github.com/thoughtbot/bamboo#getting-started)

## Using templates

The Postmark adapter provides a helper module for setting the template of an
email.

### Example

```elixir
defmodule MyApp.Mail do
  import Bamboo.PostMarkHelper

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
