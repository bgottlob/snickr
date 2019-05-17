defmodule SnickrWeb.InviteController do
  use SnickrWeb, :controller

  alias Snickr.Repo
  alias Snickr.Accounts
  alias Snickr.Accounts.{AdminInvitation, MembershipInvitation, SubscriptionInvitation}

  plug :authenticate_user

  def index(conn, _attrs) do
    membershipinvitations =
      Accounts.workspace_pending_invites(conn.assigns.current_user)
      |> Repo.preload(:workspace)
      |> Repo.preload(:invited_by_user)

    admininvitations =
      Accounts.workspace_pending_admin_invites(conn.assigns.current_user)
      |> Repo.preload(:workspace)
      |> Repo.preload(:invited_by_user)

    subscriptioninvitations =
      Accounts.pending_subscription_invites(conn.assigns.current_user)
      |> Repo.preload(:channel)
      |> Repo.preload(:invited_by_user)

    render(conn, "index.html",
      membershipinvitations: membershipinvitations,
      admininvitations: admininvitations,
      subscriptioninvitations: subscriptioninvitations
    )
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", membershipinvitation: Accounts.get_membership_invitation!(id))
  end

  def create(conn, %{"invite" => %{"workspace_id" => workspace_id} = attrs}) do
    attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)

    case Accounts.create_membership_invitation(attrs) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "You have successfully invited the user")
        |> redirect(to: Routes.workspace_path(conn, :show, invite.workspace_id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Inviting the user failed, please try again")
        |> redirect(to: Routes.workspace_path(conn, :show, workspace_id))
    end
  end

  def create_admin(conn, %{"invite" => %{"workspace_id" => workspace_id} = attrs}) do
    attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)

    case Accounts.create_admin_invitation(attrs) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "You have successfully invited the user")
        |> redirect(to: Routes.workspace_path(conn, :show, invite.workspace_id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Inviting the user failed, please try again")
        |> redirect(to: Routes.workspace_path(conn, :show, workspace_id))
    end
  end

  def create_subscription(conn, %{"invite" => %{"channel_id" => channel_id} = attrs}) do
    attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)

    case Accounts.create_subscription_invitation(attrs) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "You have successfully invited the user")
        |> redirect(to: Routes.channel_path(conn, :show, invite.channel_id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Inviting the user failed, please try again")
        |> redirect(to: Routes.channel_path(conn, :show, channel_id))
    end
  end

  def accept(conn, %{"id" => id}) do
    case Accounts.accept_membership_invitation(Repo.get(MembershipInvitation, id)) do
      {:ok, %{:membership_invitation => mi}} ->
        mi = Repo.preload(mi, :workspace)

        conn
        |> put_flash(:info, "Welcome to #{mi.workspace.name}!")
        |> redirect(to: Routes.workspace_path(conn, :show, mi.workspace.id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> redirect(to: Routes.invite_path(conn, :index))
    end
  end

  def accept_admin(conn, %{"id" => id}) do
    case Accounts.accept_admin_invitation(Repo.get(AdminInvitation, id)) do
      {:ok, %{:admin_invitation => ai}} ->
        ai = Repo.preload(ai, :workspace)

        conn
        |> put_flash(:info, "You are an admin of #{ai.workspace.name}!")
        |> redirect(to: Routes.workspace_path(conn, :show, ai.workspace.id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> redirect(to: Routes.invite_path(conn, :index))
    end
  end

  def accept_subscription(conn, %{"id" => id}) do
    case Accounts.accept_subscription_invitation(Repo.get(SubscriptionInvitation, id)) do
      {:ok, %{:subscription_invitation => si}} ->
        si = Repo.preload(si, :channel)

        conn
        |> put_flash(:info, "Welcome to #{si.channel.name}!")
        |> redirect(to: Routes.channel_path(conn, :show, si.channel.id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> redirect(to: Routes.invite_path(conn, :index))
    end
  end
end
