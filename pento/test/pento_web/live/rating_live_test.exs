defmodule PentoWeb.RatingLiveTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures
  import Pento.SurveyFixtures
  alias PentoWeb.RatingLive

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_product_with_no_ratings(_) do
    product =
      product_fixture()
      |> Map.put(:ratings, [])

    %{product: product}
  end

  defp create_rating(product, user) do
    rating_fixture(%{user_id: user.id, product_id: product.id})
  end

  defp create_product_with_rating(rating, product_no_rating) do
    product_no_rating
    |> Map.put(:ratings, [rating])
  end

  describe "RatingLive.Index" do
    setup [:create_user, :create_product_with_no_ratings]

    test "when no rating is present, the rating form is rendered", %{
      user: current_user,
      product: product
    } do
      assert render_component(&RatingLive.Index.product_list/1,
               products: [product],
               current_user: current_user
             ) =~ "rating-form-#{product.id}"
    end

    test "when there is a rating, rating details are rendered", %{
      user: current_user,
      product: product
    } do
      product =
        create_rating(product, current_user)
        |> create_product_with_rating(product)

      html =
        render_component(&RatingLive.Index.product_list/1,
          products: [product],
          current_user: current_user
        )

      refute html =~ "rating-form-#{product.id}"
      assert html =~ "&#x2605;"
    end
  end
end
