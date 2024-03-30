defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> clear_form()}
  end

  def assign_rating(socket) do
    rating = %Rating{
      user_id: socket.assigns.current_user.id,
      product_id: socket.assigns.product.id
    }

    assign(socket, :rating, rating)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def clear_form(socket) do
    changeset = Survey.change_rating(socket.assigns.rating)
    assign_form(socket, changeset)
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def save_rating(%{assigns: %{product: product, product_index: product_index}} = socket, rating_params) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = Map.put(product, :ratings, [rating])
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, changeset} ->
        assign_form(socket, changeset)
    end
  end
end
