defmodule PentoWeb.SurveyLiveTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Demographic" do
    setup [:register_and_log_in_user]

    test "submit demographic shows demographic data", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/survey")

      view
      |> form("#demographic-form",
        demographic: %{
          "gender" => "female",
          "year_of_birth" => "1998",
          "education" => "high school"
        }
      )
      |> render_submit()

      :timer.sleep(2)
      result = render(view)

      assert result =~ "Gender: female"
      assert result =~ "Year of birth: 1998"
      assert result =~ "Education: high school"
    end
  end
end
