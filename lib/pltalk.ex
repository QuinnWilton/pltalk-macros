defmodule PLTalk do
  defmacro my_if(predicate, do: block, else: otherwise) do
    IO.inspect(predicate, label: :if)
    IO.inspect(block, label: :do)
    IO.inspect(otherwise, label: :else)

    quote bind_quoted: [
            predicate: predicate,
            block: block,
            otherwise: otherwise
          ] do
      cond do
        predicate in [nil, false] ->
          otherwise

        true ->
          block
      end
    end
  end
end
