defmodule Pento.Game.Pentomino do
  alias Pento.Game.Point
  alias Pento.Game.Shape
  @moduledoc false
  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}

  defstruct name: @names |> Enum.at(0),
            rotation: 0,
            reflected: false,
            location: @default_location

  def new(fields \\ []), do: __struct__(fields)

  def rotate(%__MODULE__{rotation: degrees} = pentomino) do
    Map.put(pentomino, :rotation, rem(degrees + 90, 360))
  end

  def flip(%__MODULE__{reflected: reflection} = pentomino) do
    Map.put(pentomino, :reflected, not reflection)
  end

  def up(pentomino), do: Map.put(pentomino, :location, Point.move(pentomino.location, {0, -1}))
  def down(pentomino), do: Map.put(pentomino, :location, Point.move(pentomino.location, {0, 1}))
  def left(pentomino), do: Map.put(pentomino, :location, Point.move(pentomino.location, {-1, 0}))
  def right(pentomino), do: Map.put(pentomino, :location, Point.move(pentomino.location, {1, 0}))

  def to_shape(pentomino) do
		Shape.new(pentomino.name, pentomino.rotation, pentomino.reflected, pentomino.location)
  end
end
