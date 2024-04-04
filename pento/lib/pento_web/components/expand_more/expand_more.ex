defmodule PentoWeb.ExpandMore do
  use Phoenix.Component
  import PentoWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :expanded, :boolean, default: true
  slot :inner_block

  def expand_more(assigns) do
    ~H"""
    <div class="mt-2 mb-2">
      <.button type="button" phx-click={toggle_visibility(@id)} name="toggle-visibility-button">
	      <%= if @expanded do %>
          - contract
        <%= else %>
          + expand
        <% end %>
			</.button>
      <div id={@id} class={not @expanded && "hidden"}>
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
