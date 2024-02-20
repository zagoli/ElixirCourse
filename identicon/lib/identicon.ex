defmodule Identicon do
  def main(name) do
    name
    |> hash_md5
    |> pick_color
    |> build_grid
  end

  def hash_md5(string) do
    %Identicon.Image{seed: :crypto.hash(:md5, string) |> :binary.bin_to_list()}
  end

  def pick_color(%Identicon.Image{seed: [red, green, blue | _tail]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def build_grid(%Identicon.Image{seed: num_list} = image) do
    grid =
      num_list
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()
      |> filter_odd_numbers

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Calculates the coordinates of a square given its index in a 5x5 grid
  ## Examples
      iex> index = 0
      iex> coordinates = Identicon.get_square_coordinates(index)
      iex> coordinates
      {{0, 0}, {50, 50}}

      iex> index = 7
      iex> coordinates = Identicon.get_square_coordinates(index)
      iex> coordinates
      {{100, 50}, {150, 100}}
  """
  def get_square_coordinates(square_index) do
      square_size_px = 50
      x = rem(square_index, 5) * square_size_px
      y = div(square_index, 5) * square_size_px
      top_left = {x, y}
      bottom_right = {x + square_size_px, y + square_size_px}
      {top_left, bottom_right}
  end

  @doc """
  Removes all odd "squares" from the grid
  ## Examples
      iex> grid = [{13, 0}, {2, 1}, {14, 2}, {13, 3}]
      iex> filtered_grid = Identicon.filter_odd_numbers(grid)
      iex> filtered_grid
      [{2, 1}, {14, 2}]

      iex> grid = []
      iex> filtered_grid = Identicon.filter_odd_numbers(grid)
      iex> filtered_grid
      []
  """
  def filter_odd_numbers(grid) do
    Enum.filter(grid, fn {code, _idx} ->
      rem(code, 2) == 0
    end)
  end

  @doc """
  Mirrors a row of numbers
  ## Examples
      iex> row = [1, 2, 3]
      iex> mirrored_row = Identicon.mirror_row(row)
      iex> mirrored_row
      [1, 2, 3, 2, 1]
  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end
end
