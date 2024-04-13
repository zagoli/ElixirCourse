defmodule PentoWeb.RatingLiveTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures
  alias PentoWeb.RatingLive

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_product_with_no_ratings(_) do
    product = product_fixture() |> Map.put(:ratings, [])
    %{product: product}
  end

  describe "RatingLive.Index" do
    setup [:create_product_with_no_ratings, :create_user]

    test "when no rating is present, the rating form is rendered", %{
      product: product,
      user: current_user
    } do
      products = [product]

      assert render_component(&RatingLive.Index.product_list/1,
               products: products,
               current_user: current_user
             ) =~ "rating-form-#{product.id}"
    end
  end
end
