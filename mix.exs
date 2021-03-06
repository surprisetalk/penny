defmodule Penny.Mixfile do
  use Mix.Project

  def project do
    [app: :penny,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :mongodb, :plug, :cowboy, :poison],
     mod: {Penny.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:mongodb, ">= 0.0.0"},
      {:plug, ">= 0.0.0"},
      {:cowboy, ">= 0.0.0"},
      {:poison, ">= 0.0.0"}
    ]
  end
end
