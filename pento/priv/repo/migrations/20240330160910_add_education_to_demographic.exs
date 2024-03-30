defmodule Pento.Repo.Migrations.AddEducationToDemographic do
  use Ecto.Migration

  def change do
		alter table(:demographics) do
			add :education, :string
		end
  end
end
