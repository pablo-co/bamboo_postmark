defmodule Bamboo.PostmarkAdapterTest do
  use ExUnit.Case
  alias Bamboo.Email
  alias Bamboo.PostmarkAdapter
  alias Bamboo.PostmarkHelper

  @config %{adapter: PostmarkAdapter, api_key: "123_abc"}
  @config_with_bad_key %{adapter: PostmarkAdapter, api_key: nil}

  defmodule FakePostmark do
    use Plug.Router

    plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
    plug :match
    plug :dispatch

    def start_server(parent) do
      Agent.start_link(fn -> Map.new end, name: __MODULE__)
      Agent.update(__MODULE__, &Map.put(&1, :parent, parent))
      port = get_free_port()
      Application.put_env(:bamboo, :postmark_base_uri, "http://localhost:#{port}")
      Plug.Adapters.Cowboy.http __MODULE__, [], port: port, ref: __MODULE__
    end

    defp get_free_port do
      {:ok, socket} = :ranch_tcp.listen(port: 0)
      {:ok, port} = :inet.port(socket)
      :erlang.port_close(socket)
      port
    end

    def shutdown do
      Plug.Adapters.Cowboy.shutdown __MODULE__
    end

    post "email" do
      case get_in(conn.params, ["From"]) do
        "INVALID_EMAIL" ->
          conn |> send_resp(500, "Error!!") |> send_to_parent
        _ ->
          conn |> send_resp(200, "SENT") |> send_to_parent
      end
    end

    post "email/withTemplate" do
      case get_in(conn.params, ["From"]) do
        "INVALID_EMAIL" ->
          conn |> send_resp(500, "Error!!") |> send_to_parent
        _ ->
          conn |> send_resp(200, "SENT") |> send_to_parent
      end
    end

    defp send_to_parent(conn) do
      parent = Agent.get(__MODULE__, fn(set) -> Map.get(set, :parent) end)
      send parent, {:fake_postmark, conn}
      conn
    end
  end

  setup do
    FakePostmark.start_server(self())

    on_exit fn ->
      FakePostmark.shutdown
    end

    :ok
  end

  test "raises if the api key is nil" do
    assert_raise ArgumentError, ~r/no API key set/, fn ->
      PostmarkAdapter.deliver(new_email(from: "foo@bar.com"), @config_with_bad_key)
    end

    assert_raise ArgumentError, ~r/no API key set/, fn ->
      PostmarkAdapter.handle_config(%{})
    end
  end

  test "deliver/2 passes the request_options to hackney" do
    request_options = [recv_timeout: 0]
    config = Map.put(@config, :request_options, request_options)

    assert_raise Bamboo.PostmarkAdapter.ApiError, fn ->
      PostmarkAdapter.deliver(new_email(), config)
    end
  end

  test "deliver/2 returns the textual body of the request" do
    response = PostmarkAdapter.deliver(new_email(), @config)

    assert response.body == "SENT"
  end

  test "deliver/2 makes the request to the right url" do
    PostmarkAdapter.deliver(new_email(), @config)

    assert_receive {:fake_postmark, %{request_path: request_path}}

    assert request_path == "/email"
  end

  test "deliver/2 sends the to the right url for templates" do
    new_email() |> PostmarkHelper.template("hello") |> PostmarkAdapter.deliver(@config)

    assert_receive {:fake_postmark, %{request_path: request_path}}

    assert request_path == "/email/withTemplate"
  end

  test "deliver/2 sends from, html and text body, subject, and headers" do
    email =
      [
        from: {"From", "from@foo.com"},
        subject: "My Subject",
        text_body: "TEXT BODY",
        html_body: "HTML BODY",
      ]
      |> new_email()
      |> Email.put_header("Reply-To", "reply@foo.com")

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: params}}
    assert params["From"] == "#{elem(email.from, 0)} <#{elem(email.from, 1)}>"
    assert params["Subject"] == email.subject
    assert params["TextBody"] == email.text_body
    assert params["HtmlBody"] == email.html_body
    assert params["Headers"] ==
      [%{"Name" => "Reply-To", "Value" => "reply@foo.com"}]
  end

  test "deliver/2 correctly formats recipients" do
    email = new_email(
      to: [{"To", "to@bar.com"}],
      cc: [{"CC", "cc@bar.com"}],
      bcc: [{"BCC", "bcc@bar.com"}],
    )

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: params}}
    assert params["To"] == "To <to@bar.com>"
    assert params["Bcc"] == "BCC <bcc@bar.com>"
    assert params["Cc"] == "CC <cc@bar.com>"
  end

  test "deliver/2 puts template name and empty content" do
    email = PostmarkHelper.template(new_email(), "hello")

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: %{"TemplateId" => template_id,
       "TemplateModel" => template_model}}}
    assert template_id == "hello"
    assert template_model == %{}
  end

  test "deliver/2 puts template name and content" do
    email = PostmarkHelper.template(new_email(), "hello", [
      %{name: 'example name', content: 'example content'}
    ])

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: %{"TemplateId" => template_id,
       "TemplateModel" => template_model}}}
    assert template_id == "hello"
    assert template_model == [%{"content" => 'example content',
      "name" => 'example name'}]
  end

  test "deliver/2 puts tag param" do
    email = PostmarkHelper.tag(new_email(), "some_tag")

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: %{"Tag" => "some_tag"}}}
  end

  test "deliver/2 puts tracking params" do
    email =
      new_email()
      |> PostmarkHelper.template("hello")
      |> PostmarkHelper.put_param("TrackOpens", true)
      |> PostmarkHelper.put_param("TrackLinks", "HtmlOnly")

    PostmarkAdapter.deliver(email, @config)

    assert_receive {:fake_postmark, %{params: %{
      "TrackLinks" => "HtmlOnly", "TrackOpens" => true, "TemplateId" => "hello"}
    }}
  end

  test "raises if the response is not a success" do
    email = new_email(from: "INVALID_EMAIL")

    assert_raise Bamboo.PostmarkAdapter.ApiError, fn ->
      PostmarkAdapter.deliver(email, @config)
    end
  end

  defp new_email(attrs \\ []) do
    [from: "foo@bar.com", to: []]
    |> Keyword.merge(attrs)
    |> Email.new_email()
    |> Bamboo.Mailer.normalize_addresses()
  end
end
