defmodule MediaServer.Repo.Migrations.CreateMediaAudioTable do
  use Ecto.Migration

  def change do
    create table(:media_audio) do
      add :media_id, references(:media, on_delete: :nothing), null: false

      add :duration, :decimal, precision: 20, scale: 6, null: false

      timestamps()
    end

    create unique_index(:media_audio, [:media_id])
  end
end
