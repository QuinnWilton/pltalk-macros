defmodule Contracts.Example do
  use Contracts

  @contract even?(n :: integer) :: boolean
  def even?(n) do
    rem(n, 2) == 0
  end

  @contract broken_odd?(n :: integer) :: boolean
  def broken_odd?(n) do
    if rem(n, 2) == 0 do
      false
    else
      "true"
    end
  end
end
