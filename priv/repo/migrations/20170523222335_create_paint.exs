defmodule PaintPickerWithChannels.Repo.Migrations.CreatePaint do
  use Ecto.Migration

  def change do
    create table(:paints) do
      add :cart, :integer
      add :color, :string
      add :sheen, :string
      add :picked, :boolean, default: false, null: false

      timestamps()
    end

  end
end
