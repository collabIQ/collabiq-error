defmodule CollabiqErrorTest do
  use ExUnit.Case
  doctest CollabiqError

  test "standard errors" do
    assert CollabiqError.format({:error, %{key: :site_id, code: "can't be blank"}}) ==
             {:error, [%{message: "site_id is required", code: "site_id_required"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "does not exist"}}) ==
              {:error, [%{message: "site_id was not found", code: "site_id_not_found"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "has already been taken"}}) ==
      {:error, [%{message: "site_id must be unique", code: "site_id_unique"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "invalid"}}) ==
      {:error, [%{message: "site_id is invalid", code: "site_id_invalid"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "is invalid"}}) ==
      {:error, [%{message: "site_id is invalid", code: "site_id_invalid"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "not_found"}}) ==
      {:error, [%{message: "site_id was not found", code: "site_id_not_found"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "required"}}) ==
      {:error, [%{message: "site_id is required", code: "site_id_required"}]}

    assert CollabiqError.format({:error, %{key: :site_id, code: "unique"}}) ==
      {:error, [%{message: "site_id must be unique", code: "site_id_unique"}]}
  end

  test "list of standard errors" do
    errors =
      {:error,
       [
         %{key: :user_id, code: "does not exist"},
         %{key: :site_id, code: "has already been taken"}
       ]}

    assert CollabiqError.format(errors) ==
             {:error,
              [
                %{code: "user_id_not_found", message: "user_id was not found"},
                %{code: "site_id_unique", message: "site_id must be unique"}
              ]}
  end

  test "standard error with string key" do
    assert CollabiqError.format({:error, %{key: "site_id", code: "can't be blank"}}) ==
             {:error, [%{message: "site_id is required", code: "site_id_required"}]}
  end

  test "error without map" do
    assert CollabiqError.format({:error, "blah"}) ==
      {:error, [%{message: "something went wrong", code: "error"}]}
  end

  test "changeset errors" do
    assert CollabiqError.format({:error, [name: {"can't be blank", [validation: :required]}]}) ==
      {:error, [%{message: "name is required", code: "name_required"}]}
  end

  test "error with unknown message" do
    assert CollabiqError.format({:error, %{key: :site_id, code: "blah"}}) ==
             {:error, [%{message: "something went wrong", code: "error"}]}
  end
end
