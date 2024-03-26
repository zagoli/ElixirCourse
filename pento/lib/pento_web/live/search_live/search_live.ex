defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Search.Term
  alias Pento.Search
  alias Pento.Catalog

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> remove_product()
     |> assign_search_input()
     |> clear_form()}
  end

  def assign_search_input(socket) do
    socket
    |> assign(:search_input, %Term{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.search_input
      |> Search.change_search_input()
      |> to_form()

    assign(socket, :form, form)
  end

  def remove_product(socket) do
    assign(socket, :product, nil)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"term" => term_params},
        socket
      ) do
    changeset =
      socket.assigns.search_input
      |> Search.change_search_input(term_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "search",
        %{"term" => term_params},
        socket
      ) do
    changeset =
      socket.assigns.search_input
      |> Search.change_search_input(term_params)

    if changeset.valid? do
      handle_search_product(
        Catalog.get_product_by_sku(Map.get(term_params, "search_input")),
        socket
      )
    else
      changeset = Map.put(changeset, :action, :validate)
      {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_search_product({:ok, product}, socket) do
    {:noreply,
     socket
     |> assign(:product, product)
     |> clear_form()}
  end

  def handle_search_product({:error, _}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "No product found matching the given SKU")
     |> remove_product()
     |> clear_form()}
  end
end
