# PhxHelpers

Set of commonly used funcitons for phoenix projects

## Installation

```elixir
def deps do
  [
    {:phx_helpers, git: git@github.com:ponyesteves/phx_helpers.git}
  ]
end
```

## Usage

### Config `(config/confix.exs)`

```elixir
# required for I18n related functions
config :phx_helpers, :gettext_module, MateWeb.Gettext

# required for render_shared
config :phx_helpers, :shared_view_module, MateWeb.SharedView
```

