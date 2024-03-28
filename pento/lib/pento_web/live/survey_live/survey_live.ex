defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive
  alias Pento.Survey

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic}
  end

  defp assign_demographic(socket) do
	  user = socket.assigns.current_user
	  socket
	  |> assign(:demographic, Survey.get_demographic_by_user(user))
  end

  def handle_info({:created_demographic, demographic}, socket) do
	  {:noreply, handle_demographic_created(socket, demographic)}
  end

  defp handle_demographic_created(socket, demographic) do
	  socket
	  |> put_flash(:info, "Demographic saved successfully")
	  |> assign(:demographic, demographic)
  end

end
