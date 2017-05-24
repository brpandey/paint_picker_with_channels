defmodule PaintPickerWithChannels.PaintTest do
  use PaintPickerWithChannels.ModelCase

  alias PaintPickerWithChannels.Paint

  @valid_attrs %{cart: 42, color: "some content", picked: true, sheen: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Paint.changeset(%Paint{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Paint.changeset(%Paint{}, @invalid_attrs)
    refute changeset.valid?
  end
end
