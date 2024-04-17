defmodule PentoWeb.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.GameLive.Board
  import PentoWeb.GameLive.Component

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok, assign(socket, :puzzle, puzzle)}
  end

  def render(assigns) do
    ~H"""
    <section class="container">
      <h1 class="font-heavy text-3xl">Welcome to Pento!</h1>
      <.control_panel view_box="0 0 200 40">
        <.triangle x={50} y={0} fill="#B9D7DA" rotate={0} />
        <.triangle x={13} y={-60} fill="#B9D7DA" rotate={90} />
        <.triangle x={-42.5} y={-18} fill="#B9D7DA" rotate={180} />
        <.triangle x={-4.5} y={31} fill="#B9D7DA" rotate={270} />
      </.control_panel>
      <.live_component module={Board} puzzle={@puzzle} id="game" />
    </section>
    """
  end
end
