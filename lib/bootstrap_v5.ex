defmodule PhxHelpers.BootstrapV5 do
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag
  import Phoenix.LiveView.Helpers

  @doc """
    maps every field_input from HTML.Form
  """
  @fields ~w(
    email_input
    password_input
    telephone_input
    text_input
    )a

  for src_name <- @fields do
    dest_name = "b5_#{src_name}" |> String.to_atom()

    def unquote(dest_name)(%{form: f, label: label_name, field: field} = assigns) do
      original_fx = unquote(src_name)

      ~H"""
      <div class="mb-3">
        <%= label f, label_name, class: "form-label" %>
        <%= apply(Phoenix.HTML.Form, original_fx, [f, field, [required: required(assigns), class: "form-control"]]) %>
        <%= b5_error_tag f, :name %>
      </div>
      """
    end
  end

  defp required(assigns) do
    assigns[:required] || false
  end

  def b5_checkbox(%{form: f, label: label_name, field: field} = assigns) do
    ~H"""
    <div class="mb-3 form-check">
      <%= checkbox f, field, class: "form-check-input" %>
      <%= label f, field, label_name, class: "form-check-label" %>
    </div>
    """
  end

  def b5_select(%{form: f, label: label_name, field: field, options: options } = assigns) do
    ~H"""
    <div class="mb-3 ">
      <%= label f, label_name, class: "form-label" %>
      <%= select f, field, options, class: "form-select" %>
    </div>
    """
  end

  def b5_submit(%{label: label_name} = assigns) do
    ~H"""
    <div class="mt-3">
      <%= submit label_name, class: "btn btn-primary" %>
    </div>
    """
  end

  def b5_submit_cancel(%{label: label_name, cancel_label: cancel_label, cancel_path: cancel_path} = assigns) do
    ~H"""
    <div class="mt-3">
      <%= submit label_name, class: "btn btn-primary me-3" %>
      <%= link cancel_label, to: cancel_path %>
    </div>
    """
  end

  def b5_error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:div, b5_translate_error(error),
        class: "invalid-feedback d-block",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  def b5_translate_error({msg, opts}) do
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
