defmodule Contracts.Prototype do
  def even?(n) do
    unless is_integer(n) do
      raise "Expected integer!"
    end

    result = rem(n, 2) == 0

    unless is_boolean(result) do
      raise "Expected boolean!"
    end

    result
  end
end
