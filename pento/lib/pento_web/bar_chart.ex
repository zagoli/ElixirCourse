defmodule PentoWeb.BarChart do
  alias Contex.{Dataset, BarChart, Plot}

  def make_bar_chart_dataset(products) do
	  Dataset.new(products)
  end

  def make_bar_chart(dataset) do
	  BarChart.new(dataset)
  end

  def plot_chart(%BarChart{} = chart, title, subtitle, x_label, y_label) do
	  Plot.new(500, 400, chart)
	  |> Plot.titles(title, subtitle)
	  |> Plot.axis_labels(x_label, y_label)
	  |> Plot.to_svg()
  end

end
