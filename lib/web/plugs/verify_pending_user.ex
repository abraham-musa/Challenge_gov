defmodule Web.Plugs.VerifyPendingUser do
  @moduledoc """
  Verify a _admin_ user is in the session
  """

  import Plug.Conn
  import Phoenix.Controller

  alias ChallengeGov.Accounts
  alias Web.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    case is_pending?(conn) do
      true ->
        conn

      false ->
        conn
        |> redirect(to: Routes.admin_dashboard_path(conn, :index))
        |> halt()
    end
  end

  defp is_pending?(conn) do
    case Map.fetch(conn.assigns, :current_user) do
      {:ok, user} ->
        Accounts.is_pending?(user)

      :error ->
        false
    end
  end
end
