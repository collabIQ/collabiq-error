defmodule CollabiqError do
  @moduledoc false

  # Handles multiple errors in a list and recursively sends
  # the back through format/1
  def format({:error, errors}) when is_list(errors) do
    errors =
      errors
      |> Enum.map(&format/1)

    {:error, errors}
  end

  def format({:error, error}), do: {:error, [format(error)]}

  # Pattern matches errors produced by Ecto
  def format({key, {msg, _opts}}) do
    error = %{key: to_string(key), code: msg}
    error |> lookup()
  end

  # Pattern matches most errors produced by CollabIQ
  def format(%{key: key, code: code}) do
    error = %{key: to_string(key), code: to_string(code)}
    error |> lookup()
  end

  def format(error), do: error |> lookup()

  defp lookup(%{key: key, code: "can't be blank"}),
    do: %{message: "#{key} is required", code: "#{key}_required"}

  defp lookup(%{key: _key, code: "is already in this org"}),
    do: %{message: "user is already of member of this organization", code: "user_org_member"}

  defp lookup(%{key: key, code: "does not exist"}),
    do: %{message: "#{key} was not found", code: "#{key}_not_found"}

  defp lookup(%{key: key, code: "has already been taken"}),
    do: %{message: "#{key} must be unique", code: "#{key}_unique"}

  defp lookup(%{key: key, code: "invalid"}),
    do: %{message: "#{key} is invalid", code: "#{key}_invalid"}

  defp lookup(%{key: key, code: "is invalid"}),
    do: %{message: "#{key} is invalid", code: "#{key}_invalid"}

  defp lookup(%{key: key, code: "not_found"}),
    do: %{message: "#{key} was not found", code: "#{key}_not_found"}

  defp lookup(%{key: key, code: "required"}),
    do: %{message: "#{key} is required", code: "#{key}_required"}

  defp lookup(%{key: key, code: "unique"}),
    do: %{message: "#{key} must be unique", code: "#{key}_unique"}

  defp lookup(%{key: _key, code: _code}),
    do: %{message: "something went wrong", code: "error"}

  defp lookup(_), do: %{message: "something went wrong", code: "error"}
end
