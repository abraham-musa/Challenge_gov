defmodule Web.ChallengeController do
  use Web, :controller

  # alias ChallengeGov.Accounts
  # alias ChallengeGov.Challenges

  plug Web.Plugs.FetchPage, [per: 6] when action in [:index]
  plug :check_email_verification when action in [:new, :create]

  action_fallback(Web.FallbackController)

  def index(conn, _params) do
    # %{page: page, per: per} = conn.assigns
    # filter = Map.get(params, "filter", %{})
    # pagination = Challenges.all(filter: filter, page: page, per: per)

    # conn
    # |> assign(:challenges, pagination.page)
    # |> assign(:pagination, pagination.pagination)
    # |> assign(:filter, filter)
    # |> render("index.html")
    conn
  end

  def show(conn, %{"id" => _id}) do
    # with {:ok, challenge} <- Challenges.get(id),
    #      {:ok, challenge} <- Challenges.filter_for_created(challenge) do
    #   conn
    #   |> assign(:challenge, challenge)
    #   |> assign(:events, challenge.events)
    #   |> assign(:supporting_documents, challenge.supporting_documents)
    #   |> render("show.html")
    # end
    conn
  end

  def new(conn, _params) do
    # %{current_user: user} = conn.assigns

    # conn
    # |> assign(:changeset, Challenges.new(user))
    # |> render("new.html")
    conn
  end

  def create(conn, %{"challenge" => _params}) do
    # %{current_user: user} = conn.assigns

    # case Challenges.submit(user, params) do
    #   {:ok, _challenge} ->
    #     conn
    #     |> put_flash(
    #       :info,
    #       "Thank you for submitting a challenge! Your challenge will show up here after review by the Hack Baltimore team."
    #     )
    #     |> redirect(to: Routes.challenge_path(conn, :index))

    #   {:error, changeset} ->
    #     conn
    #     |> assign(:changeset, changeset)
    #     |> put_status(422)
    #     |> render("new.html")
    # end
    conn
  end

  defp check_email_verification(conn, _opts) do
    # %{current_user: user} = conn.assigns

    # case Accounts.email_verified?(user) do
    #   true ->
    #     conn

    #   false ->
    #     conn
    #     |> put_flash(:error, "You must verify your email address first.")
    #     |> redirect(to: Routes.page_path(conn, :index))
    #     |> halt()
    # end
    conn
  end
end
