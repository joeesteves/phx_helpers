defmodule PhxHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_helpers,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_html, "~> 2.11"},
      {:gettext, "~> 0.11"},
      {:timex, "~> 3.6"},
      {:number, "~> 1.0"}
    ]
  end
end
