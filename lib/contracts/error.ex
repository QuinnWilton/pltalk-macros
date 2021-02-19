defmodule Contracts.Error do
  defexception [:mfa, :where, :type, :value]

  def message(error) do
    "#{mfa(error.mfa)} expected #{error.type} for #{error.where}, got #{inspect(error.value)}"
  end

  defp mfa({module, function, arity}) do
    "#{module}.#{function}/#{arity}"
  end
end
