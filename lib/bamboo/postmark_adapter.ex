defmodule Bamboo.PostmarkAdapter do
  @behaviour Bamboo.Adapter

  @default_base_uri "https://api.postmarkapp.com"
  @send_email_path "email"
  @send_email_template_path "email/withTemplate"

  defmodule ApiError do
    defexception [:message]

    def exception(%{message: message}) do
      %ApiError{message: message}
    end

    def exception(%{params: params, response: response}) do
      filtered_params = params |> Poison.decode!

      message = """
      There was a problem sending the email through the Postmark API.
      Here is the response:
      #{inspect response, limit: :infinity}

      Here are the params we sent:

      #{inspect filtered_params, limit: :infinity}

      If you are deploying to Heroku and using ENV variables to handle your API key,
      you will need to explicitly export the variables so they are available at compile time.
      Add the following configuration to your elixir_buildpack.config:

      config_vars_to_export=(
      DATABASE_URL
      POSTMARK_API_KEY
      )
      """
      %ApiError{message: message}
    end
  end

  def deliver(email, config) do
    api_key = get_key(config)
    params = email |> convert_to_postmark_params() |> Poison.encode!
    uri = [base_uri(), "/", api_path(email)]

    case :hackney.post(uri, headers(api_key), params, [:with_body]) do
      {:ok, status, _headers, response} when status > 299 ->
        raise(ApiError, %{params: params, response: response})
      {:ok, status, headers, response} ->
        %{status_code: status, headers: headers, body: response}
      {:error, reason} ->
        raise(ApiError, %{message: inspect(reason)})
    end
  end

  def handle_config(config) do
    if config[:api_key] in [nil, ""] do
      raise_api_key_error(config)
    else
      config
    end
  end

  defp get_key(config) do
    if config[:api_key] in [nil, ""] do
      raise_api_key_error(config)
    else
      config[:api_key]
    end
  end

  defp raise_api_key_error(config) do
    raise ArgumentError, """
    There was no API key set for the Postmark adapter.
    * Here are the config options that were passed in:
    #{inspect config}
    """
  end

  defp convert_to_postmark_params(email) do
    email_params(email) |> maybe_put_template_params(email)
  end

  defp maybe_put_template_params(params, %{private:
    %{template_id: template_name, template_model: template_model}}) do
    params
    |> Map.put(:"TemplateId", template_name)
    |> Map.put(:"TemplateModel", template_model)
    |> Map.put(:"InlineCss", true)
  end

  defp maybe_put_template_params(params, _) do
    params
  end

  defp email_params(email) do
    recipients = recipients(email)
    %{
      "From": email_from(email),
      "To": recipients_to_string(recipients, "To"),
      "Cc": recipients_to_string(recipients, "Cc"),
      "Bcc": recipients_to_string(recipients, "Bcc"),
      "Subject": email.subject,
      "TextBody": email.text_body,
      "HtmlBody": email.html_body,
      "Headers": email_headers(email),
      "TrackOpens": true
    }
  end

  defp email_from(email) do
    name = email.from |> elem(0)
    email = email.from |> elem(1)
    if name do
      String.trim("#{name} <#{email}>")
    else
      String.trim(email)
    end
  end

  defp email_headers(email) do
    Enum.map(email.headers,
              fn {header, value} -> %{"Name": header, "Value": value } end)
  end

  defp recipients(email) do
    []
    |> add_recipients(email.to, type: "To")
    |> add_recipients(email.cc, type: "Cc")
    |> add_recipients(email.bcc, type: "Bcc")
  end

  defp add_recipients(recipients, new_recipients, type: recipient_type) do
    Enum.reduce(new_recipients, recipients, fn(recipient, recipients) ->
      recipients ++ [%{
        name: recipient |> elem(0),
        email: recipient |> elem(1),
        type: recipient_type
      }]
    end)
  end

  defp recipients_to_string(recipients, type) do
    recipients
    |> Enum.filter(fn(recipient) -> recipient[:type] == type end)
    |> Enum.map_join(",", fn(rec) -> "#{rec[:name]} <#{rec[:email]}>" end)
  end

  defp headers(api_key) do
    [{"accept", "application/json"},
     {"content-type", "application/json"},
     {"x-postmark-server-token", api_key}]
  end

  defp api_path(%{private: %{template_id: _}}), do: @send_email_template_path
  defp api_path(_), do: @send_email_path

  defp base_uri do
    Application.get_env(:bamboo, :postmark_base_uri) || @default_base_uri
  end
end
