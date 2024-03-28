defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic
     |> clear_form}
  end

  defp assign_demographic(socket) do
    assign(socket, :demographic, %Demographic{user_id: socket.assigns.current_user.id})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(socket) do
    socket |> assign_form(Survey.change_demographic(socket.assigns.demographic))
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    changeset = Survey.change_demographic(socket.assigns.demographic, demographic_params)

    {:noreply,
     socket
     |> assign_form(changeset)
     |> Map.put(:action, :validate)}
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    demographic_params = add_user_id_to_demographic_params(demographic_params, socket)
    {:noreply, save_demographic(socket, demographic_params)}
  end

  def add_user_id_to_demographic_params(params, %{assigns: %{current_user: current_user}}) do
    params |> Map.put("user_id", current_user.id)
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, changeset} ->
        assign_form(socket, changeset)
    end
  end
end
