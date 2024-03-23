defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(%Recipient{} = recipient, attrs \\ %{}) do
    # send the email
    changeset = Recipient.changeset(recipient, attrs)

    if changeset.valid? do
      {:ok, changeset}
      # send the email
    else
      {:error, changeset}
    end
  end
end
