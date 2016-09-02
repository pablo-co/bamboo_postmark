defmodule BambooPostmark.Mixfile do
  use Mix.Project

  @project_url "https://github.com/pablo-co/bamboo_postmark"

  def project do
    [app: :bamboo_postmark,
     version: "0.1.0",
     elixir: "~> 1.2",
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
    [applications: [:logger, :hackney]]
  end

  defp deps do
    [{:bamboo, "~> 0.7.0"},
     {:hackney, "~> 1.6"},
     {:poison, ">= 1.5.0"},
     {:plug, "~> 1.0"},
     {:cowboy, "~> 1.0", only: [:test, :dev]}]
  end

  defp package do
    [
      maintainers: ["Pablo Cárdenas"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end
end
