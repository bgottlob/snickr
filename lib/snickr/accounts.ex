defmodule Snickr.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Snickr.Repo

  alias Snickr.Accounts.{Admin, Membership, Subscription, User}
  alias Snickr.Platform.{Channel, Message, Workspace}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
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
    Repo.all from c in Channel,
      join: u in assoc(c, :subscribers),
      where: u.id == ^user_id
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
    !!Repo.one(from m in Membership,
               where: m.user_id == ^user.id and m.workspace_id == ^workspace.id)
  end

  def admin?(%User{} = user, %Workspace{} = workspace) do
    !!Repo.one(from a in Admin,
               where: a.user_id == ^user.id and a.workspace_id == ^workspace.id)
  end

  def subscriber?(%User{} = user, %Channel{} = channel) do
    !!Repo.one(from s in Subscription,
               where: s.user_id == ^user.id and s.channel_id == ^channel.id)
  end
end
