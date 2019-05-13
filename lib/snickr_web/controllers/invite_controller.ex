defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Accounts
    alias Snickr.Accounts.MembershipInvitation
    
    def index(conn, _attrs) do
        render(conn, "index.html", membershipinvitations: Accounts.workspace_pending_invites(conn.assigns.current_user))
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
end