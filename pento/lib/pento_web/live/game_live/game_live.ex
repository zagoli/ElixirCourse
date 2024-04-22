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
      <div class="grid grid-cols-2">
        <div>
          <h1 class="font-heavy text-3xl text-center">
            Welcome to Pento!
          </h1>
        </div>
        <.help />
      </div>
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

  def help(assigns) do
    ~H"""
    <div>
      <.help_button />
      <.help_page />
    </div>
    """
  end

  attr :class, :string, default: "h-8 w-8 text-slate hover:text-slate-400"

  def help_button(assigns) do
    ~H"""
    <button phx-click={JS.toggle(to: "#info")}>
      <.icon name="hero-question-mark-circle-solid" class="mini" />
    </button>
    """
  end

  def help_page(assigns) do
    ~H"""
    <div id="info" hidden class="fixed hidden bg-white mx-4 border border-2">
      <ul class="mx-8 list-disc">
        <li>Click on a pento to pick it up</li>
        <li>Drop a pento with a space</li>
        <li>Pentos can't overlap</li>
        <li>Pentos must be fully on the board</li>
        <li>Rotate a pento with shift</li>
        <li>Flip a pento with enter</li>
        <li>Place all the pentos to win</li>
      </ul>
    </div>
    """
  end
end
