defmodule Snickr.AccountsTest do
  use Snickr.DataCase

  alias Snickr.Accounts

  describe "users" do
    alias Snickr.Accounts.User

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "some password",
      username: "some username"
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name"
    }
    @invalid_attrs %{
      email: nil,
      first_name: nil,
      last_name: nil,
      password_hash: nil,
      username: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    @tag :skip
    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.password == nil
      assert String.length(user.password_hash) > 0
      assert String.length(Map.get(@valid_attrs, :password)) > 0
      assert user.password_hash != Map.get(@valid_attrs, :password)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    @tag :skip
    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
    end

    @tag :skip
    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    @tag :skip
    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    @tag :skip
    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "memberships" do
    alias Snickr.Accounts.Membership

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def membership_fixture(attrs \\ %{}) do
      {:ok, membership} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_membership()

      membership
    end

    @tag :skip
    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Accounts.list_memberships() == [membership]
    end

    @tag :skip
    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Accounts.get_membership!(membership.id) == membership
    end

    @tag :skip
    test "create_membership/1 with valid data creates a membership" do
      assert {:ok, %Membership{} = membership} = Accounts.create_membership(@valid_attrs)
    end

    @tag :skip
    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_membership(@invalid_attrs)
    end

    @tag :skip
    test "update_membership/2 with valid data updates the membership" do
      membership = membership_fixture()

      assert {:ok, %Membership{} = membership} =
               Accounts.update_membership(membership, @update_attrs)
    end

    @tag :skip
    test "update_membership/2 with invalid data returns error changeset" do
      membership = membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_membership(membership, @invalid_attrs)
      assert membership == Accounts.get_membership!(membership.id)
    end

    @tag :skip
    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Accounts.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_membership!(membership.id) end
    end

    @tag :skip
    test "change_membership/1 returns a membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Accounts.change_membership(membership)
    end
  end

  describe "admins" do
    alias Snickr.Accounts.Admin

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def admin_fixture(attrs \\ %{}) do
      {:ok, admin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_admin()

      admin
    end

    @tag :skip
    test "list_admins/0 returns all admins" do
      admin = admin_fixture()
      assert Accounts.list_admins() == [admin]
    end

    @tag :skip
    test "get_admin!/1 returns the admin with given id" do
      admin = admin_fixture()
      assert Accounts.get_admin!(admin.id) == admin
    end

    @tag :skip
    test "create_admin/1 with valid data creates a admin" do
      assert {:ok, %Admin{} = admin} = Accounts.create_admin(@valid_attrs)
    end

    @tag :skip
    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_admin(@invalid_attrs)
    end

    @tag :skip
    test "update_admin/2 with valid data updates the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{} = admin} = Accounts.update_admin(admin, @update_attrs)
    end

    @tag :skip
    test "update_admin/2 with invalid data returns error changeset" do
      admin = admin_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_admin(admin, @invalid_attrs)
      assert admin == Accounts.get_admin!(admin.id)
    end

    @tag :skip
    test "delete_admin/1 deletes the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{}} = Accounts.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_admin!(admin.id) end
    end

    @tag :skip
    test "change_admin/1 returns a admin changeset" do
      admin = admin_fixture()
      assert %Ecto.Changeset{} = Accounts.change_admin(admin)
    end
  end

  describe "subscriptions" do
    alias Snickr.Accounts.Subscription

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_subscription()

      subscription
    end

    @tag :skip
    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Accounts.list_subscriptions() == [subscription]
    end

    @tag :skip
    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Accounts.get_subscription!(subscription.id) == subscription
    end

    @tag :skip
    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Accounts.create_subscription(@valid_attrs)
    end

    @tag :skip
    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_subscription(@invalid_attrs)
    end

    @tag :skip
    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()

      assert {:ok, %Subscription{} = subscription} =
               Accounts.update_subscription(subscription, @update_attrs)
    end

    @tag :skip
    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_subscription(subscription, @invalid_attrs)

      assert subscription == Accounts.get_subscription!(subscription.id)
    end

    @tag :skip
    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Accounts.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_subscription!(subscription.id) end
    end

    @tag :skip
    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Accounts.change_subscription(subscription)
    end
  end

  describe "subscriptioninvitations" do
    alias Snickr.Accounts.SubscriptionInvitation

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def subscription_invitation_fixture(attrs \\ %{}) do
      {:ok, subscription_invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_subscription_invitation()

      subscription_invitation
    end

    @tag :skip
    test "list_subscriptioninvitations/0 returns all subscriptioninvitations" do
      subscription_invitation = subscription_invitation_fixture()
      assert Accounts.list_subscriptioninvitations() == [subscription_invitation]
    end

    @tag :skip
    test "get_subscription_invitation!/1 returns the subscription_invitation with given id" do
      subscription_invitation = subscription_invitation_fixture()
      assert Accounts.get_subscription_invitation!(subscription_invitation.id) == subscription_invitation
    end

    @tag :skip
    test "create_subscription_invitation/1 with valid data creates a subscription_invitation" do
      assert {:ok, %SubscriptionInvitation{} = subscription_invitation} = Accounts.create_subscription_invitation(@valid_attrs)
      assert subscription_invitation.status == "some status"
    end

    @tag :skip
    test "create_subscription_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_subscription_invitation(@invalid_attrs)
    end

    @tag :skip
    test "update_subscription_invitation/2 with valid data updates the subscription_invitation" do
      subscription_invitation = subscription_invitation_fixture()
      assert {:ok, %SubscriptionInvitation{} = subscription_invitation} = Accounts.update_subscription_invitation(subscription_invitation, @update_attrs)
      assert subscription_invitation.status == "some updated status"
    end

    @tag :skip
    test "update_subscription_invitation/2 with invalid data returns error changeset" do
      subscription_invitation = subscription_invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_subscription_invitation(subscription_invitation, @invalid_attrs)
      assert subscription_invitation == Accounts.get_subscription_invitation!(subscription_invitation.id)
    end

    @tag :skip
    test "delete_subscription_invitation/1 deletes the subscription_invitation" do
      subscription_invitation = subscription_invitation_fixture()
      assert {:ok, %SubscriptionInvitation{}} = Accounts.delete_subscription_invitation(subscription_invitation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_subscription_invitation!(subscription_invitation.id) end
    end

    @tag :skip
    test "change_subscription_invitation/1 returns a subscription_invitation changeset" do
      subscription_invitation = subscription_invitation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_subscription_invitation(subscription_invitation)
    end
  end

  describe "membershipinvitations" do
    alias Snickr.Accounts.MembershipInvitation

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def membership_invitation_fixture(attrs \\ %{}) do
      {:ok, membership_invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_membership_invitation()

      membership_invitation
    end

    @tag :skip
    test "list_membershipinvitations/0 returns all membershipinvitations" do
      membership_invitation = membership_invitation_fixture()
      assert Accounts.list_membershipinvitations() == [membership_invitation]
    end

    @tag :skip
    test "get_membership_invitation!/1 returns the membership_invitation with given id" do
      membership_invitation = membership_invitation_fixture()
      assert Accounts.get_membership_invitation!(membership_invitation.id) == membership_invitation
    end

    @tag :skip
    test "create_membership_invitation/1 with valid data creates a membership_invitation" do
      assert {:ok, %MembershipInvitation{} = membership_invitation} = Accounts.create_membership_invitation(@valid_attrs)
      assert membership_invitation.status == "some status"
    end

    @tag :skip
    test "create_membership_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_membership_invitation(@invalid_attrs)
    end

    @tag :skip
    test "update_membership_invitation/2 with valid data updates the membership_invitation" do
      membership_invitation = membership_invitation_fixture()
      assert {:ok, %MembershipInvitation{} = membership_invitation} = Accounts.update_membership_invitation(membership_invitation, @update_attrs)
      assert membership_invitation.status == "some updated status"
    end

    @tag :skip
    test "update_membership_invitation/2 with invalid data returns error changeset" do
      membership_invitation = membership_invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_membership_invitation(membership_invitation, @invalid_attrs)
      assert membership_invitation == Accounts.get_membership_invitation!(membership_invitation.id)
    end

    @tag :skip
    test "delete_membership_invitation/1 deletes the membership_invitation" do
      membership_invitation = membership_invitation_fixture()
      assert {:ok, %MembershipInvitation{}} = Accounts.delete_membership_invitation(membership_invitation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_membership_invitation!(membership_invitation.id) end
    end

    @tag :skip
    test "change_membership_invitation/1 returns a membership_invitation changeset" do
      membership_invitation = membership_invitation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_membership_invitation(membership_invitation)
    end
  end

  describe "admininvitations" do
    alias Snickr.Accounts.AdminInvitation

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def admin_invitation_fixture(attrs \\ %{}) do
      {:ok, admin_invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_admin_invitation()

      admin_invitation
    end

    @tag :skip
    test "list_admininvitations/0 returns all admininvitations" do
      admin_invitation = admin_invitation_fixture()
      assert Accounts.list_admininvitations() == [admin_invitation]
    end

    @tag :skip
    test "get_admin_invitation!/1 returns the admin_invitation with given id" do
      admin_invitation = admin_invitation_fixture()
      assert Accounts.get_admin_invitation!(admin_invitation.id) == admin_invitation
    end

    @tag :skip
    test "create_admin_invitation/1 with valid data creates a admin_invitation" do
      assert {:ok, %AdminInvitation{} = admin_invitation} = Accounts.create_admin_invitation(@valid_attrs)
      assert admin_invitation.status == "some status"
    end

    @tag :skip
    test "create_admin_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_admin_invitation(@invalid_attrs)
    end

    @tag :skip
    test "update_admin_invitation/2 with valid data updates the admin_invitation" do
      admin_invitation = admin_invitation_fixture()
      assert {:ok, %AdminInvitation{} = admin_invitation} = Accounts.update_admin_invitation(admin_invitation, @update_attrs)
      assert admin_invitation.status == "some updated status"
    end

    @tag :skip
    test "update_admin_invitation/2 with invalid data returns error changeset" do
      admin_invitation = admin_invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_admin_invitation(admin_invitation, @invalid_attrs)
      assert admin_invitation == Accounts.get_admin_invitation!(admin_invitation.id)
    end

    @tag :skip
    test "delete_admin_invitation/1 deletes the admin_invitation" do
      admin_invitation = admin_invitation_fixture()
      assert {:ok, %AdminInvitation{}} = Accounts.delete_admin_invitation(admin_invitation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_admin_invitation!(admin_invitation.id) end
    end

    @tag :skip
    test "change_admin_invitation/1 returns a admin_invitation changeset" do
      admin_invitation = admin_invitation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_admin_invitation(admin_invitation)
    end
  end
end
