defmodule PhxHelpers.BootstrapV5 do
  import Phoenix.HTML.Form
  import Phoenix.LiveView.Helpers

  @doc """
    maps every field_input from HTML.Form
  """

  for src_name <- ~w(email_input password_input)a do
    dest_name = "b5_#{src_name}" |> String.to_atom()

    def unquote(dest_name)(%{form: f, label: label_name, field: field} = assigns) do
      original_fx = unquote(src_name)

      ~H"""
      <div class="mb-3">
        <%= label f, label_name, class: "form-label" %>
        <%= apply(Phoenix.HTML.Form, original_fx, [f, field, [required: true, class: "form-control"]]) %>
      </div>
      """
    end
  end

  def b5_checkbox(%{form: f, label: label_name, field: field} = assigns) do
    ~H"""
    <div class="mb-3 form-check">
      <%= checkbox f, field, class: "form-check-input" %>
      <%= label f, field, label_name, class: "form-check-label" %>
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
end
