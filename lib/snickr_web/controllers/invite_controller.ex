defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Accounts
    alias Snickr.Accounts.MembershipInvitation
    
    def index(conn, _attrs) do
        render(conn, "index.html")
    end

    def show(conn, _params) do
        render(conn, "show.html", membershipinvitations: Accounts.workspace_pending_invites(conn.assigns.current_user))
    end

end