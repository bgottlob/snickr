defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Repo
    alias Snickr.Accounts
    alias Snickr.Accounts.{AdminInvitation, MembershipInvitation}

    plug :authenticate_user when action in [:index, :show, :create, :accept]
    
    def index(conn, _attrs) do
        membershipinvitations =
            Accounts.workspace_pending_invites(conn.assigns.current_user)
            |> Repo.preload(:workspace)
            |> Repo.preload(:invited_by_user)
        admininvitations =
            Accounts.workspace_pending_admin_invites(conn.assigns.current_user)
            |> Repo.preload(:workspace)
            |> Repo.preload(:invited_by_user)
        render(conn, "index.html", membershipinvitations: membershipinvitations, admininvitations: admininvitations)
    end

    def show(conn, %{"id" => id}) do
        render(conn, "show.html", membershipinvitation: Accounts.get_membership_invitation!(id))
    end

    # Modify the pattern match to make sure we have a workspace_id to return to in the error path
    def create(conn, %{"invite" => %{"workspace_id" => workspace_id} = attrs}) do
    attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)
        case Accounts.create_membership_invitation(attrs) do
        # This is not a transaction, only a single insert, so a map won't be returned
        {:ok, invite} ->
            conn
            |> put_flash(:info, "You have successfully invited the user")
            |> redirect(to: Routes.workspace_path(conn, :show, invite.workspace_id))
        # We can keep the error handling pretty generic for now
        {:error, _reason} ->
            conn
            |> put_flash(:error, "Inviting the user failed, please try again")
            |> redirect(to: Routes.workspace_path(conn, :show, workspace_id))
        end
    end

    def create_admin(conn, %{"invite" => %{"workspace_id" => workspace_id} = attrs}) do
        attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)
            case Accounts.create_admin_invitation(attrs) do
            # This is not a transaction, only a single insert, so a map won't be returned
            {:ok, invite} ->
                conn
                |> put_flash(:info, "You have successfully invited the user")
                |> redirect(to: Routes.workspace_path(conn, :show, invite.workspace_id))
            # We can keep the error handling pretty generic for now
            {:error, _reason} ->
                conn
                |> put_flash(:error, "Inviting the user failed, please try again")
                |> redirect(to: Routes.workspace_path(conn, :show, workspace_id))
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
end
