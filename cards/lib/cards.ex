# iex -S mix

defmodule Cards do
    @moduledoc """
    Provides methods for creating and handling a deck of cards
    """

    @doc """
    Returns a list of strings representing a deck of poker cards
    """
    def create_deck do
        values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
        suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

        for suit <- suits, value <- values do
            "#{value} of #{suit}"
        end
    end

    def shuffle(deck) do
        Enum.shuffle(deck)
    end

    @doc """
    Determines whether a deck contains a given card
    ## Examples
        iex> deck = Cards.create_deck()
        iex> Cards.contains?(deck, "Ace of Spades")
        true
    """
    def contains?(deck, hand) do
        Enum.member?(deck, hand)
    end

    @doc """
    Divides a deck into a hand with size `hand_size` and the remainder of the deck.
    ## Examples
        iex> deck = Cards.create_deck()
        iex> {hand, _deck} = Cards.deal(deck, 1)
        iex> hand
        ["Ace of Spades"]
    """
    def deal(deck, hand_size) do
        Enum.split(deck, hand_size)
    end

    def save(deck, filename) do
        serialized = :erlang.term_to_binary(deck)
        File.write(filename, serialized)
    end

    def load(filename) do
        case File.read(filename) do
            {:ok, serialized} -> :erlang.binary_to_term(serialized)
            {:error, _} -> "Error reading #{filename}"
        end
    end
	
	def create_hand(hand_size) do
		Cards.create_deck()
		|> Cards.shuffle()
		|> Cards.deal(hand_size)
	end

end