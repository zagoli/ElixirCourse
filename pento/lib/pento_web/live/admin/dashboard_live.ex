defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"
  @user_activity_products_topic "user_activity_products"
  @user_activity_survey_topic "user_activity_survey"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_products_topic)
      Endpoint.subscribe(@user_activity_survey_topic)
    end

    {:ok,
     assign(
       socket,
       survey_results_component_id: "survey-results",
       user_activity_products_component_id: "user-activity-products",
       user_activity_survey_component_id: "user-activity-survey"
     )}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      PentoWeb.Admin.SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{topic: @user_activity_products_topic, event: "presence_diff"}, socket) do
    send_update(
      PentoWeb.Admin.UserActivityProductsLive,
      id: socket.assigns.user_activity_products_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{topic: @user_activity_survey_topic, event: "presence_diff"}, socket) do
    send_update(
      PentoWeb.Admin.UserActivitySurveyLive,
      id: socket.assigns.user_activity_survey_component_id
    )

    {:noreply, socket}
  end
end
