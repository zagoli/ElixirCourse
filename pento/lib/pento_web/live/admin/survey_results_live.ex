defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  alias Pento.Catalog
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_svg_chart()}
  end

  defp assign_age_group_filter(socket, age_group_filter \\ "all") do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp assign_products_with_average_ratings(%{assigns: assigns} = socket) do
    assign(
      socket,
      :products_with_average_ratings,
      get_products_with_average_ratings(
        Catalog.products_with_average_ratings(%{age_group_filter: assigns.age_group_filter})
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

  defp make_bar_chart_dataset(products) do
    Contex.Dataset.new(products)
  end

  defp assign_chart(%{assigns: assigns} = socket) do
    assign(socket, :chart, make_bar_chart(assigns.dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  defp assign_svg_chart(%{assigns: assigns} = socket) do
    assign(socket, :svg_chart, plot_chart(assigns.chart))
  end

  defp plot_chart(%Contex.BarChart{} = chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles("Product Ratings", "average star rating per product")
    |> Plot.axis_labels("products", "stars")
    |> Plot.to_svg()
  end

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset
     |> assign_chart
     |> assign_svg_chart}
  end
end
