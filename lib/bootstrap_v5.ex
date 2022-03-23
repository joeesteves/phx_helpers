defmodule PhxHelpers.BootstrapV5 do
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag
  import Phoenix.LiveView.Helpers
  use Phoenix.Component

  @doc """
    maps every field_input from HTML.Form
  """
  @fields ~w(
    date_input
    email_input
    password_input
    telephone_input
    text_input
    )a

  @wrapper_base_class "mb-3"
  @label_base_class "form-label"
  @input_base_class "form-control"

  for src_name <- @fields do
    dest_name = "b5_#{src_name}" |> String.to_atom()

    def unquote(dest_name)(f, field, opts \\ []) do
      original_fx = unquote(src_name)
      input_base_class = unquote(@input_base_class)
      label_base_class = unquote(@label_base_class)

      content = [
        label(f, opts[:label], class: label_base_class),
        apply(Phoenix.HTML.Form, original_fx, [
          f,
          field,
          build_opts(f, field, opts, input_base_class)
        ]),
        b5_error_tag(f, field)
      ]

      content_tag(:div, content, class: compact([@wrapper_base_class, opts[:wrapper_class]]))
    end
  end

  defp compact(list) do
    Enum.reject(list, &is_nil(&1))
    |> Enum.join(" ")
  end

  def b5_checkbox(f, field, opts \\ []) do
    content = [
      label(f, opts[:label], class: "form-check-label"),
      checkbox(f, field, build_opts(f, field, opts, "form-check-input")),
      b5_error_tag(f, field)
    ]

    content_tag(:div, content, class: compact([@wrapper_base_class, opts[:wrapper_class]]))
  end

  def b5_select(f, field, options, opts \\ []) do
    content = [
      label(f, opts[:label], class: @label_base_class),
      select(f, field, options, build_opts(f, field, opts, "form-select")),
      b5_error_tag(f, field)
    ]

    content_tag(:div, content, class: compact([@wrapper_base_class, opts[:wrapper_class]]))
  end

  def b5_submit(label, opts \\ []) do
    content = submit(label, class: compact(["btn btn-primary me-3", opts[:class]]))

    content_tag(:div, content, class: compact([@wrapper_base_class, opts[:wrapper_class]]))
  end

  def b5_submit_and_back_to(label, opts \\ []) do
    {back_to, opts} =
      pop_required_option!(opts, :back_to, "expected non-nil value for :back_to in link/2")

    {back_to_label, opts} =
      pop_required_option!(
        opts,
        :back_to_label,
        "expected non-nil value for :back_to_label in link/2"
      )

    content = [
      submit(label, class: compact(["btn btn-primary me-3", opts[:class]])),
      link(back_to_label, to: back_to)
    ]

    content_tag(:div, content, class: compact([@wrapper_base_class, opts[:wrapper_class]]))
  end

  defp pop_required_option!(opts, key, error_message) do
    {value, opts} = Keyword.pop(opts, key)

    unless value do
      raise ArgumentError, error_message
    end

    {value, opts}
  end

  defp build_opts(form, field, opts, default_field_class) do
    [class: form_control_class(default_field_class, form, field, opts)]
    |> Keyword.merge(opts)
  end

  defp form_control_class(default_class, form, field, assigns) do
    valid_class =
      case form do
        %{source: %Ecto.Changeset{action: action}} when action in ~w(insert update)a ->
          (Keyword.get_values(form.errors, field) |> Enum.any?() && "is-invalid") || "is-valid"

        _ ->
          nil
      end

    [default_class, valid_class, assigns[:class]] |> Enum.reject(&is_nil(&1)) |> Enum.join(" ")
  end

  defp b5_error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:div, b5_translate_error(error),
        class: "invalid-feedback d-block",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  defp b5_translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(PhxHelpers.get_config(:gettext_module), "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(PhxHelpers.get_config(:gettext_module), "errors", msg, opts)
    end
  end
end

defimpl Phoenix.HTML.Safe, for: Map do
  def to_iodata(data), do: data |> Jason.encode!() |> Plug.HTML.html_escape()
end
