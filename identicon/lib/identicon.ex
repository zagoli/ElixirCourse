defmodule Identicon do

    def main(name) do
        name
        |> hash_md5
    end

    def hash_md5(string) do
        %Identicon.Image{
            seed:   :crypto.hash(:md5, string)
                    |> :binary.bin_to_list
        }
    end

end
