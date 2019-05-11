defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Accounts
    alias Snickr.Accounts.MembershipInvitation
    
    def index(conn, _attrs) do
        render(conn, "index.html", membershipinvitations: Accounts.workspace_pending_invites(conn.assigns.current_user))
    end

    def show(conn, %{"id" => id}) do
        render(conn, "show.html", membershipinvitation: Accounts.get_membershipinvitation(id))
    end

end