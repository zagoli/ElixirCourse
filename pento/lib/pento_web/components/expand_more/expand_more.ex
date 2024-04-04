defmodule PentoWeb.ExpandMore do
  use Phoenix.Component
  import PentoWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  slot :inner_block

  def expand_more(assigns) do
    ~H"""
    <div class="mt-2">
      <.button phx-click={toggle_visibility(@id)} >toggle content</.button>
      <div id={@id}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp toggle_visibility(js \\ %JS{}, id) do
		js
		|> JS.toggle(to: "##{id}")
  end
end
