defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.{DemographicLive, RatingLive, Endpoint}
  alias Pento.{Survey, Catalog}

  @survey_results_topic "survey_results"


  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demographic
     |> assign_products}
  end

  defp assign_demographic(socket) do
    user = socket.assigns.current_user

    socket
    |> assign(:demographic, Survey.get_demographic_by_user(user))
  end

  defp assign_products(socket) do
    user = socket.assigns.current_user

    socket
    |> assign(:products, Catalog.list_products_with_user_rating(user))
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, product, product_index}, socket) do
	  {:noreply, handle_product_rating_created(socket, product, product_index)}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic saved successfully")
    |> assign(:demographic, demographic)
  end

  def handle_product_rating_created(%{assigns: %{products: product_list}} = socket, product, product_index) do
	  Endpoint.broadcast(@survey_results_topic, "rating_created", %{})
	  socket
	  |> put_flash(:info, "Rating submitted successfully")
	  |> assign(:products, List.replace_at(product_list, product_index, product))
  end
end
