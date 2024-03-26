defmodule Pento.Search do
  alias Pento.Search.Term

  def change_search_input(%Term{} = term, attrs \\ %{}) do
	  Term.changeset(term, attrs)
  end

end
