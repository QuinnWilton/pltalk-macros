defmodule Mime do
  @external_resource "priv/mime.types"

  mapping =
    File.stream!("priv/mime.types")
    |> Enum.reject(&String.starts_with?(&1, ["#", "\n"]))
    |> Enum.map(fn line ->
      [type | exts] =
        line
        |> String.trim()
        |> String.downcase()
        |> String.split()

      {type, exts}
    end)
    |> Enum.filter(fn {_, exts} -> exts != [] end)

  # Dynamically define extension_to_type/1
  for {type, exts} <- mapping,
      ext <- exts do
    def extension_to_type(unquote(ext)), do: unquote(type)
  end

  def extension_to_type(_ext), do: nil

  # Dynamically define type_to_extensions/1
  for {type, exts} <- mapping do
    def type_to_extensions(unquote(type)), do: unquote(exts)
  end

  def type_to_extensions(_type), do: nil
end
