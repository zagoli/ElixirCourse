defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live
  alias Pento.Catalog

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_gender_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_svg_chart()}
  end

  defp assign_age_group_filter(socket, age_group_filter \\ "all") do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp assign_gender_filter(socket, gender_filter \\ "all") do
    assign(socket, :gender_filter, gender_filter)
  end

  defp assign_products_with_average_ratings(%{assigns: assigns} = socket) do
    assign(
      socket,
      :products_with_average_ratings,
      get_products_with_average_ratings(
        Catalog.products_with_average_ratings(%{
          age_group_filter: assigns.age_group_filter,
          gender_filter: assigns.gender_filter
        })
      )
    )
  end

  defp get_products_with_average_ratings([]) do
    Catalog.products_with_zero_ratings()
  end

  defp get_products_with_average_ratings(products) do
    products
  end

  defp assign_dataset(%{assigns: assigns} = socket) do
    assign(socket, :dataset, make_bar_chart_dataset(assigns.products_with_average_ratings))
  end

  defp assign_chart(%{assigns: assigns} = socket) do
    assign(socket, :chart, make_bar_chart(assigns.dataset))
  end

  defp assign_svg_chart(%{assigns: assigns} = socket) do
    assign(
      socket,
      :svg_chart,
      plot_chart(
        assigns.chart,
        "Survey results",
        "Average star ratings for products",
        "product",
        "stars"
      )
    )
  end

  def handle_event("filter_results", %{"age_group_filter" => age_group_filter, "gender_filter" => gender_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_gender_filter(gender_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset
     |> assign_chart
     |> assign_svg_chart}
  end

end
