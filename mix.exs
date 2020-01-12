defmodule Tracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :tracker,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers() ++ [:phoenix_swagger],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [
        tool: ExCoveralls
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tracker.Application, []},
      extra_applications: [:logger, :phoenix_swagger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:excoveralls, "~> 0.12", only: :test},
      {:phoenix, "~> 1.4.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:redix, "~> 0.10"},
      {:poison, "~> 3.0"},
      {:phoenix_swagger, "~> 0.8"},
      {:ex_json_schema, "~> 0.5"}
    ]
  end

  defp aliases do
    [
      test: ["swagger", "test"],
      swagger: ["phx.swagger.generate"]
    ]
  end
end
