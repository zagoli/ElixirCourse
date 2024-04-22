defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component
  alias Pento.Game.Board
  alias Pento.Game
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

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    board =
      puzzle
      |> String.to_existing_atom()
      |> Board.new()

    assign(socket, :board, board)
  end

  def assign_shapes(socket) do
    shapes = Board.to_shapes(socket.assigns.board)
    assign(socket, :shapes, shapes)
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply, socket |> pick(name) |> assign_shapes}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply, socket |> do_key(key) |> assign_shapes}
  end

  defp pick(socket, name) do
	  shape_name = String.to_existing_atom(name)
	  update(socket, :board, &Board.pick(&1, shape_name))
  end

  defp do_key(socket, key) do
    case key do
      " " -> drop(socket)
      "Space" -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "Enter" -> move(socket, :flip)
      _ -> socket
    end
  end

  defp move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} -> put_flash(socket, :info, message)
      {:ok, board} -> socket |> assign(:board, board) |> assign_shapes
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} -> put_flash(socket, :info, message)
      {:ok, board} -> socket |> assign(board: board) |> assign_shapes
    end
  end
end
