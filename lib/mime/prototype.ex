defmodule Mime.Prototype do
  def extension_to_type("json"), do: "application/json"
  def extension_to_type("html"), do: "text/html"
  def extension_to_type("htm"), do: "text/html"
  # ...repeated for thousands of extensions
  def extension_to_type(_ext), do: nil

  def type_to_extensions("application/json"), do: ["json"]
  def type_to_extensions("text/html"), do: ["html", "htm"]
  # ...repeated for thousands of types
  def type_to_extensions(_type), do: nil
end
