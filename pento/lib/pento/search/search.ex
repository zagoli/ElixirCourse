defmodule Pento.Search.Term do
	use Ecto.Schema

	@primary_key false
	embedded_schema do
		field :search_input, :string
	end

	import Ecto.Changeset

	def changeset(%__MODULE__{} = term, attrs) do
		term
		|> cast(attrs, [:search_input])
		|> validate_required([:search_input])
		|> validate_length(:search_input, min: 7)
	end

end
