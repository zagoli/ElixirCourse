defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       time: time(),
       answer: :rand.uniform(10)
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <p>Last try was at <%= @time %></p>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <pre>
    Username: <%= @current_user.username %>
    <%= @session_id %>
    </pre>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    answer = socket.assigns.answer
    guess = String.to_integer(guess)
    message = "Your guess was #{guess} and the answer was #{answer}."

    {score, message} =
      case guess do
        ^answer -> {socket.assigns.score + 1, "#{message} Wow, correct!"}
        _ -> {socket.assigns.score - 1, "#{message} Wrong. Guess again!"}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time(),
        answer: :rand.uniform(10)
      )
    }
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end
