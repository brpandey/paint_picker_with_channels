# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 1, color: "salmon", sheen: "gloss", picked: true })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 2, color: "tomato", sheen: "flat", picked: true })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 3, color: "darkorange", sheen: "satin", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 4, color: "indianred", sheen: "gloss", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 5, color: "greenyellow", sheen: "eggshell", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 6, color: "mediumspringgreen", sheen: "eggshell", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 7, color: "khaki", sheen: "flat", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 8, color: "gold", sheen: "flat", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 9, color: "teal", sheen: "semi-gloss", picked: false })
PaintPickerWithChannels.Repo.insert!(%PaintPickerWithChannels.Paint{ cart: 10, color: "maroon", sheen: "semi-gloss", picked: false })
