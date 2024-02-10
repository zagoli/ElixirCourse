# iex -S mix

defmodule Cards do

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

    def contains?(deck, hand) do
        Enum.member?(deck, hand)
    end

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