defmodule SnickrWeb.InviteController do
    use SnickrWeb, :controller
    
    alias Snickr.Accounts
    alias Snickr.Accounts.MembershipInvitation
    
    def index(conn, _attrs) do
        render(conn, "index.html", membershipinvitations: Accounts.list_membershipinvitations())
    end
end