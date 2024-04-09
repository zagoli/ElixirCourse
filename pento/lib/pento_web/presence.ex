defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence
  alias Pento.Catalog.Product

  @user_activity_topic "user_activity"

  def track_user(pid, %Product{} = product, user_email) when is_pid(pid) do
    Presence.track(
      pid,
      @user_activity_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  def list_products_and_users() do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas) do
    # use &(&1.users)
    Enum.map(metas, &users_from_metas_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp users_from_metas_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
