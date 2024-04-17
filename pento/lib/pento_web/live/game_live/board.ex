defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component
  alias Pento.Game.{Board, Pentomino}
  import PentoWeb.GameLive.{Component, Colors}

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_shapes()}
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(socket) do
    active = Pentomino.new(name: :p, location: {7, 2})

    completed = [
      Pentomino.new(name: :u, rotation: 270, location: {1, 2}),
      Pentomino.new(name: :v, rotation: 90, location: {4, 2})
    ]

    Board.puzzles() # atom must exist!

    board =
      socket.assigns.puzzle
      |> String.to_existing_atom()
      |> Board.new()
      |> Map.put(:completed_pentos, completed)
      |> Map.put(:active_pento, active)

    assign(socket, :board, board)
  end

  def assign_shapes(socket) do
	  shape = Board.to_shape(socket.assigns.board)
	  assign(socket, :shapes, [shape])
  end
end
