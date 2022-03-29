defmodule PhxHelpers do
  @moduledoc """
  Documentation for `PhxHelpers`.
  """

  import Phoenix.HTML.Form, only: [label: 4]
  import Phoenix.HTML, only: [sigil_E: 2]

  def get_config(key) do
    case Application.get_env(:phx_helpers, key) do
      nil -> raise RuntimeError, message: "Missing config :phx_helpers, #{key}"
      mod -> mod
    end
  end

  def render_shared(path, assigns, content \\ [])

  def render_shared(path, assigns, content) when is_list(assigns) do
    content = (Enum.any?(content) && content) || [do: assigns[:do]]
    render_shared_on(get_config(:shared_view_module), path, assigns, content)
  end

  def render_shared_on(view_module, path, assigns, content \\ [])

  def render_shared_on(view_module, path, assigns, content) when is_map(assigns) do
    render_shared_on(view_module, path, Enum.into(assigns, []), content)
  end

  def render_shared_on(view_module, path, assigns, content) when is_list(assigns) do
    Phoenix.View.render(view_module, path, assigns ++ [content: content[:do]])
  end

  def current_path_match?(conn, regex) do
    path = Phoenix.Controller.current_path(conn)

    String.match?(path, regex)
  end

  @spec maybe_text(String.t(), boolean()) :: String.t()
  def maybe_text(text, true), do: text
  def maybe_text(_, _), do: ""

  def t(msg) do
    Gettext.gettext(get_config(:gettext_module), msg)
  end

  def dt(msg) do
    Gettext.dgettext(get_config(:gettext_module), "labels", "#{msg}")
  end

  def tlabel(form, attr_key, opts \\ []) do
    label(
      form,
      attr_key,
      Gettext.dgettext(get_config(:gettext_module), "labels", Atom.to_string(attr_key)),
      opts
    )
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

  def format_date(date, :short) do
    Timex.format!(date, "%d-%m-%y", :strftime)
  end

  def to_select(enum) do
    Enum.map(enum, &{&1.name, &1.id})
  end
end
