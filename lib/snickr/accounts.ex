defmodule Snickr.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Snickr.Repo

  alias Snickr.Accounts.{Admin, Membership, Subscription, User, MembershipInvitation}
  alias Snickr.Platform.{Channel, Message, Workspace}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def workspace_pending_invites(%User{} = user) do
    Repo.all(from m in MembershipInvitation,
  join: u in assoc(m, :user),
  where: u.id == ^user.id and m.status == "pending")
  end

  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user omitting the password hash for security.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Map.put(:password_hash, nil)
    |> Map.put(:password, nil)
  end

  def get_user(id) do
    case Repo.get(User, id) do
      nil ->
        nil

      user ->
        user
        |> Map.put(:password_hash, nil)
        |> Map.put(:password, nil)
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    # Plaintext password not be included in changeset
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def change_user(user, attrs) do
    User.create_changeset(user, attrs)
  end

  def authenticate(username, password) do
    user = from(u in User, where: u.username == ^username) |> Repo.one()

    cond do
      user && Pbkdf2.check_pass(user, password) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        # Protect against timing attacks
        Pbkdf2.no_user_verify()
        {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns the list of memberships.

  ## Examples

      iex> list_memberships()
      [%Membership{}, ...]

  """
  def list_memberships do
    Repo.all(Membership)
  end

  @doc """
  Gets a single membership.

  Raises `Ecto.NoResultsError` if the Membership does not exist.

  ## Examples

      iex> get_membership!(123)
      %Membership{}

      iex> get_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_membership!(id), do: Repo.get!(Membership, id)

  @doc """
  Deletes a Membership.

  ## Examples

      iex> delete_membership(membership)
      {:ok, %Membership{}}

      iex> delete_membership(membership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_membership(%Membership{} = membership) do
    Repo.delete(membership)
  end

  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%Admin{}, ...]

  """
  def list_admins do
    Repo.all(Admin)
  end

  @doc """
  Gets a single admin.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> get_admin!(123)
      %Admin{}

      iex> get_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin!(id), do: Repo.get!(Admin, id)

  @doc """
  Deletes a Admin.

  ## Examples

      iex> delete_admin(admin)
      {:ok, %Admin{}}

      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  @doc """
  Returns the list of channels a user is subscribed to.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriber_channels(user_id) do
    Repo.all(
      from c in Channel,
        join: u in assoc(c, :subscribers),
        where: u.id == ^user_id
    )
  end

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  def member?(%User{} = user, %Workspace{} = workspace) do
    !!Repo.one(
      from m in Membership,
        where: m.user_id == ^user.id and m.workspace_id == ^workspace.id
    )
  end

  def admin?(%User{} = user, %Workspace{} = workspace) do
    !!Repo.one(
      from a in Admin,
        where: a.user_id == ^user.id and a.workspace_id == ^workspace.id
    )
  end

  def subscriber?(%User{} = user, %Channel{} = channel) do
    !!Repo.one(
      from s in Subscription,
        where: s.user_id == ^user.id and s.channel_id == ^channel.id
    )
  end

  alias Snickr.Accounts.SubscriptionInvitation

  @doc """
  Returns the list of subscriptioninvitations.

  ## Examples

      iex> list_subscriptioninvitations()
      [%SubscriptionInvitation{}, ...]

  """
  def list_subscriptioninvitations do
    Repo.all(SubscriptionInvitation)
  end

  @doc """
  Gets a single subscription_invitation.

  Raises `Ecto.NoResultsError` if the Subscription invitation does not exist.

  ## Examples

      iex> get_subscription_invitation!(123)
      %SubscriptionInvitation{}

      iex> get_subscription_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription_invitation!(id), do: Repo.get!(SubscriptionInvitation, id)

  @doc """
  Creates a subscription_invitation.

  ## Examples

      iex> create_subscription_invitation(%{field: value})
      {:ok, %SubscriptionInvitation{}}

      iex> create_subscription_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription_invitation(attrs \\ %{}) do
    %SubscriptionInvitation{}
    |> SubscriptionInvitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subscription_invitation.

  ## Examples

      iex> update_subscription_invitation(subscription_invitation, %{field: new_value})
      {:ok, %SubscriptionInvitation{}}

      iex> update_subscription_invitation(subscription_invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription_invitation(%SubscriptionInvitation{} = subscription_invitation, attrs) do
    subscription_invitation
    |> SubscriptionInvitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SubscriptionInvitation.

  ## Examples

      iex> delete_subscription_invitation(subscription_invitation)
      {:ok, %SubscriptionInvitation{}}

      iex> delete_subscription_invitation(subscription_invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription_invitation(%SubscriptionInvitation{} = subscription_invitation) do
    Repo.delete(subscription_invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription_invitation changes.

  ## Examples

      iex> change_subscription_invitation(subscription_invitation)
      %Ecto.Changeset{source: %SubscriptionInvitation{}}

  """
  def change_subscription_invitation(%SubscriptionInvitation{} = subscription_invitation) do
    SubscriptionInvitation.changeset(subscription_invitation, %{})
  end

  alias Snickr.Accounts.MembershipInvitation

  @doc """
  Returns the list of membershipinvitations.

  ## Examples

      iex> list_membershipinvitations()
      [%MembershipInvitation{}, ...]

  """
  def list_membershipinvitations do
    Repo.all(MembershipInvitation)
  end

  @doc """
  Gets a single membership_invitation.

  Raises `Ecto.NoResultsError` if the Membership invitation does not exist.

  ## Examples

      iex> get_membership_invitation!(123)
      %MembershipInvitation{}

      iex> get_membership_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_membership_invitation!(id), do: Repo.get!(MembershipInvitation, id)

  @doc """
  Creates a membership_invitation.

  ## Examples

      iex> create_membership_invitation(%{field: value})
      {:ok, %MembershipInvitation{}}

      iex> create_membership_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_membership_invitation(attrs \\ %{}) do
    %MembershipInvitation{}
    |> MembershipInvitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a membership_invitation.

  ## Examples

      iex> update_membership_invitation(membership_invitation, %{field: new_value})
      {:ok, %MembershipInvitation{}}

      iex> update_membership_invitation(membership_invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_membership_invitation(%MembershipInvitation{} = membership_invitation, attrs) do
    membership_invitation
    |> MembershipInvitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MembershipInvitation.

  ## Examples

      iex> delete_membership_invitation(membership_invitation)
      {:ok, %MembershipInvitation{}}

      iex> delete_membership_invitation(membership_invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_membership_invitation(%MembershipInvitation{} = membership_invitation) do
    Repo.delete(membership_invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking membership_invitation changes.

  ## Examples

      iex> change_membership_invitation(membership_invitation)
      %Ecto.Changeset{source: %MembershipInvitation{}}

  """
  def change_membership_invitation(%MembershipInvitation{} = membership_invitation) do
    MembershipInvitation.changeset(membership_invitation, %{})
  end

  alias Snickr.Accounts.AdminInvitation

  @doc """
  Returns the list of admininvitations.

  ## Examples

      iex> list_admininvitations()
      [%AdminInvitation{}, ...]

  """
  def list_admininvitations do
    Repo.all(AdminInvitation)
  end

  @doc """
  Gets a single admin_invitation.

  Raises `Ecto.NoResultsError` if the Admin invitation does not exist.

  ## Examples

      iex> get_admin_invitation!(123)
      %AdminInvitation{}

      iex> get_admin_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin_invitation!(id), do: Repo.get!(AdminInvitation, id)

  @doc """
  Creates a admin_invitation.

  ## Examples

      iex> create_admin_invitation(%{field: value})
      {:ok, %AdminInvitation{}}

      iex> create_admin_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_admin_invitation(attrs \\ %{}) do
    %AdminInvitation{}
    |> AdminInvitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin_invitation.

  ## Examples

      iex> update_admin_invitation(admin_invitation, %{field: new_value})
      {:ok, %AdminInvitation{}}

      iex> update_admin_invitation(admin_invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_admin_invitation(%AdminInvitation{} = admin_invitation, attrs) do
    admin_invitation
    |> AdminInvitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AdminInvitation.

  ## Examples

      iex> delete_admin_invitation(admin_invitation)
      {:ok, %AdminInvitation{}}

      iex> delete_admin_invitation(admin_invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin_invitation(%AdminInvitation{} = admin_invitation) do
    Repo.delete(admin_invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin_invitation changes.

  ## Examples

      iex> change_admin_invitation(admin_invitation)
      %Ecto.Changeset{source: %AdminInvitation{}}

  """
  def change_admin_invitation(%AdminInvitation{} = admin_invitation) do
    AdminInvitation.changeset(admin_invitation, %{})
  end
end
