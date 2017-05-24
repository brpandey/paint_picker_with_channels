defmodule PaintPickerWithChannels.Paint do
  use PaintPickerWithChannels.Web, :model

  schema "paints" do
    field :cart, :integer
    field :color, :string
    field :sheen, :string
    field :picked, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cart, :color, :sheen, :picked])
    |> validate_required([:cart, :color, :sheen, :picked])
  end

  defimpl Poison.Encoder, for: PaintPickerWithChannels.Paint do
    def encode(model, opts) do
      %{id: model.id,
        cart: model.cart,
        color: model.color,
        sheen: model.sheen,
        picked: model.picked} |> Poison.Encoder.encode(opts)
    end
  end

end
