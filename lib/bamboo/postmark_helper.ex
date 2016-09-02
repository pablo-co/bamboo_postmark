defmodule Bamboo.PostmarkHelper do
  @moduledoc """
  Functions for using features specific to Postmark e.g. templates
  """

  alias Bamboo.Email

  @doc """
  Send emails using Postmark's template API.

  Setup Postmark to send emails using a template. Use this in conjuction with
  the template content to offload template rendering to Postmark. The
  template id specified here must match the template id in Postmark.
  Postmarks's API docs for this can be found [here](https://www.mandrillapp.com/api/docs/messages.JSON.html#method=send-template).

  ## Example

    template(email, "9746128")
    template(email, "9746128", %{"name" => "Name", "content" => "John"})
  """
  def template(email, template_id, template_model \\ []) do
    email
    |> Email.put_private(:template_id, template_id)
    |> Email.put_private(:template_model, template_model)
  end
end
