defmodule Bamboo.PostmarkHelper do
  @moduledoc """
  Functions for using features specific to Postmark's templates.
  """

  alias Bamboo.Email

  @doc """
  Set a single tag for an email that allows you to categorize outgoing emails
  and get detailed statistics.

  A convenience function for `put_private(email, :tag, "my-tag")`

  ## Examples

      tag(email, "welcome-email")

  """
  def tag(email, tag) do
    Email.put_private(email, :tag, tag)
  end

  @doc """
  Send emails using Postmark's template API.

  Setup Postmark to send emails using a template. Use this in conjuction with
  the template content to offload template rendering to Postmark. The
  template id specified here must match the template id in Postmark.
  Postmarks's API docs for this can be found [here](https://postmarkapp.com/developer/api/templates-api#email-with-template).

  ## Examples

      template(email, "9746128")
      template(email, "9746128", %{"name" => "Name", "content" => "John"})
      template(email, {:alias, "my-template-alias"}, %{"name" => "Name", "content" => "John"})

  """
  def template(email, template_id, template_model \\ %{}) do
    email
    |> Email.put_private(:template_model, template_model)
    |> put_private_template(template_id)
  end

  defp put_private_template(email, {:alias, template_alias}) do
    Email.put_private(email, :template_alias, template_alias)
  end

  defp put_private_template(email, template_id) do
    Email.put_private(email, :template_id, template_id)
  end

  @doc """
  Put extra message parameters that are used by Postmark. You can set things
  like TrackOpens, TrackLinks or Attachments.

  ## Examples

      put_param(email, "TrackLinks", "HtmlAndText")
      put_param(email, "TrackOpens", true)
      put_param(email, "Attachments", [
        %{
          Name: "file.txt",
          Content: "/some/file.txt" |> File.read!() |> Base.encode64(),
          ContentType: "txt"
        }
      ])

  """
  def put_param(%Email{private: %{message_params: _}} = email, key, value) do
    put_in(email.private[:message_params][key], value)
  end

  def put_param(email, key, value) do
    email
    |> Email.put_private(:message_params, %{})
    |> put_param(key, value)
  end
end
