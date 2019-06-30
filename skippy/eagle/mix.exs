defmodule Eagle.MixProject do
  use Mix.Project

  def project do
    [
      app: :eagle,
      version: "0.1.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Eagle.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:picam, "~> 0.3.0"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.8.2"}
    ]
  end
end
