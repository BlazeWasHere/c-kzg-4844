defmodule CKZG.MixProject do
  use Mix.Project

  @version "2.1.0"
  @source_url "https://github.com/ethereum/c-kzg-4844"

  def project do
    # Make cwd always `bindings/elixir`.
    cwd = File.cwd!()
    elixir_path = Path.join(["bindings", "elixir"])

    with false <- String.ends_with?(cwd, elixir_path),
         true <- File.dir?(Path.join(cwd, elixir_path)) do
      File.cd!(Path.join(cwd, elixir_path))
    end

    [
      app: :ckzg,
      description:
        "Elixir bindings for the C-KZG-4844 library, providing KZG polynomial commitment scheme functionality.",
      source_url: @source_url,
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_precompiler_url:
        "https://github.com/ethereum/c-kzg-4844/releases/download/v#{@version}/@{artefact_filename}",
      make_precompiler_filename: "nif",
      make_precompiler: {:nif, CCPrecompiler},
      make_precompiler_priv_paths: ["ckzg_nif.*"],
      make_force_build: Mix.env() == :test,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "native",
        "README*",
        "Makefile",
        "mix.exs",
        "../../src/*/*.[ch]",
        "../../inc/*.[ch]",
        "../../blst/*/*.[ch]"
      ],
      licenses: ["Apache-2.0"],
      links: %{"Github" => @source_url},
      maintainers: ["Blaze"]
    ]
  end

  defp docs do
    [
      extras: [
        "README.md": ["Elixir Bindings"],
        "../../README.md": [title: "Library Options"]
      ],
      markdown_processor: {ExDoc.Markdown.Earmark, footnotes: true}
    ]
  end

  defp deps do
    [
      {:cc_precompiler, "~> 0.1.10", runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:elixir_make, "~> 0.4", runtime: false},
      {:ex_doc, "~> 0.32", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:yaml_elixir, "~> 2.11.0", only: [:dev, :test], runtime: false}
    ]
  end
end
