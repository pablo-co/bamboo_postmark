defmodule BambooPostmark.Mixfile do
  use Mix.Project

  @project_url "https://github.com/pablo-co/bamboo_postmark"

  def project do
    [app: :bamboo_postmark,
     version: "1.0.0",
     elixir: "~> 1.4",
     source_url: @project_url,
     homepage_url: @project_url,
     name: "Bamboo Postmark Adapter",
     description: "A Bamboo adapter for Postmark",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:bamboo, ">= 2.0.0"},
     {:hackney, ">= 1.6.5"},
     {:poison, ">= 1.5.0", only: :test},
     {:plug, "~> 1.0"},
     {:plug_cowboy, "~> 1.0", only: [:test, :dev]},
     {:ex_doc, "~> 0.19", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Pablo Cárdenas"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end
end
