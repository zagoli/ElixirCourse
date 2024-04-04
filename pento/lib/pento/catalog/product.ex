defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Survey.Rating

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps(type: :utc_datetime)
    has_many :ratings, Rating, on_delete: :delete_all
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def decrease_unit_price_changeset(%Pento.Catalog.Product{unit_price: old_price} = product, attrs) do
	  product
	  |> cast(attrs, [:unit_price])
	  |> validate_required([:unit_price])
	  |> validate_number(:unit_price, greater_than: 0.0)
	  |> validate_number(:unit_price, less_than: old_price)
  end

end
