defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
    end

    {:ok,
     assign(
       socket,
       survey_results_component_id: "survey-results",
       user_activity_component_id: "user-activity"
     )}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      PentoWeb.Admin.SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      PentoWeb.Admin.UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    {:noreply, socket}
  end
end
