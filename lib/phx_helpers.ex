defmodule PhxHelpers do
  @moduledoc """
  Documentation for `PhxHelpers`.
  """

  import Phoenix.HTML.Form, only: [label: 3]
  import Phoenix.HTML, only: [sigil_E: 2]

  defp shared_view_module do
    case Application.get_env(:phx_helpers, :shared_view_module) do
      nil -> raise RuntimeError, message: "Missing config :phx_helpers, :shared_view_module"
      mod -> mod
    end
  end

  defp gettext_module do
    case Application.get_env(:phx_helpers, :gettext_module) do
      nil -> raise RuntimeError, message: "Missing config :phx_helpers, :gettext_module"
      mod -> mod
    end
  end

  def render_shared(path, do: shared_content) do
    Phoenix.View.render(shared_view_module(), path, shared_content: shared_content)
  end

  def render_shared(path, assigns, do: shared_content) do
    Phoenix.View.render(shared_view_module(), path, [shared_content: shared_content] ++ assigns)
  end

  def current_path_match?(conn, regex) do
    path = Phoenix.Controller.current_path(conn)

    String.match?(path, regex)
  end

  def maybe_text(text, true), do: text
  def maybe_text(_, _), do: ""

  def t(msg) do
    Gettext.gettext(gettext_module(), msg)
  end

  def dt(msg) do
    Gettext.dgettext(gettext_module(), "labels", "#{msg}")
  end

  def tlabel(form, attr_key, _opt \\ []) do
    label(form, attr_key, Gettext.dgettext(gettext_module(), "labels", Atom.to_string(attr_key)))
  end

  @format_options [
    precision: 0,
    delimiter: ".",
    separator: ",",
    format: "%n",
    negative_format: "(%n)"
  ]

  def format_number(number, opts \\ @format_options)

  def format_number(numbers, [{:sup, sup} | opts]) do
    ~E"""
      <%= format_number(numbers, opts) %><sup class="ml-1"><%= find_sup_string(sup) %></sup>
    """
  end

  def format_number(number, opts) do
    Number.Currency.number_to_currency(number, Keyword.merge(@format_options, opts))
  end

  defp find_sup_string(sup) do
    [ars: "Ars", cab: "Cab", percent: "%", kg: "Kg", kg_cab: "Kg/Cab", ars_kg: "Ars/Kg"]
    |> Keyword.fetch!(sup)
  end

  def format_currency(number) do
    Number.Currency.number_to_currency(number, @format_options)
  end

  def format_time(time) do
    Timex.format!(time, "%d-%m", :strftime)
  end
end
