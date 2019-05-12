defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Accounts
    alias Snickr.Accounts.MembershipInvitation
    
    def index(conn, _attrs) do
        render(conn, "index.html", membershipinvitations: Accounts.workspace_pending_invites(conn.assigns.current_user))
    end

    def show(conn, %{"id" => id}) do
        render(conn, "show.html", membershipinvitation: Accounts.get_membership_invitation(id))
    end

    def create(conn, %{"invite" => attrs}) do
        attrs = Map.put(attrs, "invited_by_user_id", conn.assigns.current_user.id)
        case Accounts.create_membership_invitation(attrs) do
          {:ok, %{:invite => invite}} ->
            conn
            |> put_flash(:info, "You have successfully invited the user")
            |> redirect(to: Routes.workspace_path(conn, :show, invite.workspace_id))
        end
    end
end