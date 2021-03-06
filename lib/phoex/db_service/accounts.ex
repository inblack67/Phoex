defmodule Phoex.Accounts.AccountsRepo do
  alias Phoex.Repo
  alias Phoex.Accounts.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)
    IO.inspect(user)

    cond do
      user && Argon2.verify_pass(password, user.password_hash) ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  def user_signed_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if user_id do
      Repo.get(User, user_id)
    end
  end

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  def register(input) do
    User.registration_changeset(%User{}, input)
    |> Repo.insert()
  end
end
