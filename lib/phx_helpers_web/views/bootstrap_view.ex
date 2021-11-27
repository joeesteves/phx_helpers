defmodule PhxHelpersWeb.BootstrapView do
  use Phoenix.View,
    root: "lib/phx_helpers_web/templates"
  use Phoenix.HTML

  def render("dropdown_menu", assigns) do
    PhxHelpers.render_shared_on(__MODULE__, "dropdown_menu.html", Map.merge(%{items: []}, assigns))
  end
end
