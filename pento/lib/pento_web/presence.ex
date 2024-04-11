defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence
  alias Pento.Catalog.Product

  @user_activity_products_topic "user_activity_products"
  @user_activity_survey_topic "user_activity_survey"

  def track_user_product(pid, %Product{} = product, user_email) when is_pid(pid) do
    Presence.track(
      pid,
      @user_activity_products_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  def list_products_and_users() do
    Presence.list(@user_activity_products_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas) do
    Enum.map(metas, & &1.users)
    |> List.flatten()
    |> Enum.uniq()
  end

  def track_user_survey(pid, user_email) when is_pid(pid) do
    Presence.track(
      pid,
      @user_activity_survey_topic,
      "survey",
      %{user_email: user_email}
    )
  end

  def list_survey_users() do
    Presence.list(@user_activity_survey_topic)
    |> Map.get("survey", %{metas: []})
    |> extract_survey_users()
  end

  defp extract_survey_users(%{metas: metas_list}) do
    Enum.map(metas_list, & &1.user_email)
    |> Enum.uniq()
  end
end
