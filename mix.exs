defmodule PhxHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_helpers,
      version: "1.6.1",
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
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.16.0"},
      {:gettext, "~> 0.18"},
      {:timex, "~> 3.6"},
      {:number, "~> 1.0"}
    ]
  end
end
