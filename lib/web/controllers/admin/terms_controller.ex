defmodule Web.Admin.TermsController do
  use Web, :controller

  alias ChallengeGov.Accounts

  def new(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> assign(:changeset, Accounts.edit(user))
    |> render("index.html")
  end

  def create(conn, params) do
    %{current_user: user} = conn.assigns
    data = Map.get(params, "user")
    if Map.get(data, "accept_terms_of_use") === "true" and Map.get(data, "accept_privacy_guidelines") === "true" do
      case Accounts.update(user, data) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Your account has been updated")
          |> redirect(to: Routes.admin_terms_path(conn, :pending))

        {:error, changeset} ->
          conn
          |> put_flash(:error, "There was an issue updating your account")
          |> put_status(422)
          |> assign(:changeset, changeset)
          |> render("index.html")
      end
    else
      conn
      |> put_flash(:info, "We encountered a problem submitting your information. Please try again.")
      |> render("index.html")
    end
  end

  def pending(conn, _params) do
    conn
    |> render("pending.html")
  end

end