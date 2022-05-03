defmodule EDA.MixProject do
  use Mix.Project

  def project do
    [
      app: :eda,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/gabrielkinash1/eda"
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
      {:castore, "~> 0.1.17"},
      {:mint, "~> 1.4"},
      {:mint_web_socket, "~> 1.0"},
      {:jason, "~> 1.3"}
    ]
  end
end
