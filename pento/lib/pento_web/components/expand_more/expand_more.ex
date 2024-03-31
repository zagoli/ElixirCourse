defmodule PentoWeb.ExpandMore do
  use PentoWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_default_visibility()}
  end

  defp assign_default_visibility(socket) do
    socket |> assign_new(:expanded, fn -> true end) |> assign_text
  end

  defp assign_text(socket) do
    if socket.assigns.expanded do
      socket |> assign(:text, "- contract")
    else
      socket |> assign(:text, "+ expand")
    end
  end

  attr :id, :string, required: true
  slot :inner_block

  def render(assigns) do
    ~H"""
    <div class="mt-2" id={@id}>
      <.button phx-click="toggle_visibility" phx-target={@myself}><%= @text %></.button>
      <div class={not @expanded && "hidden"}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def handle_event("toggle_visibility", _, %{assigns: %{expanded: expanded}} = socket) do
    {:noreply,
	    socket
	    |> assign(:expanded, not expanded)
	    |> assign_text}
  end
end
