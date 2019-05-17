defmodule Snickr.Platform do
  @moduledoc """
  The Platform context.
  """

  import Ecto.Query, warn: false

  alias Snickr.Repo

  alias Snickr.Platform.{Channel, Message, Workspace}
  alias Snickr.Accounts
  alias Snickr.Accounts.{Admin, Membership, Subscription, User}

  @doc """
  Returns the list of workspaces the user is a member of.
  """
  def list_workspaces(%User{} = user) do
    q =
      from w in Workspace,
        join: u in assoc(w, :members),
        where: u.id == ^user.id

    Repo.all(q)
  end

  @doc """
  Gets a single workspace.

  Raises `Ecto.NoResultsError` if the Workspace does not exist.

  ## Examples

      iex> get_workspace!(123)
      %Workspace{}

      iex> get_workspace!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workspace!(id), do: Repo.get!(Workspace, id)

  @doc """
  Gets a single workspace only if the user is a member of it.
  """
  def get_workspace_with_member(%User{} = user, workspace_id) do
    from(w in Workspace,
      join: u in assoc(w, :members),
      where: w.id == ^workspace_id and u.id == ^user.id
    )
    |> Repo.one()
  end

  @doc """
  Creates a workspace.

  ## Examples

      iex> create_workspace(%{field: value})
      {:ok, %Workspace{}}

      iex> create_workspace(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workspace(%User{} = created_by_user, attrs \\ %{}) do
    # Transaction to create the workspace, add the user who created the
    # workspace as a member and an admin
    Repo.transaction(fn ->
      workspace =
        %Workspace{}
        |> Workspace.create_changeset(created_by_user, attrs)
        |> Repo.insert!()

      %Membership{}
      |> Membership.create_changeset(created_by_user, workspace)
      |> Repo.insert!()

      %Admin{}
      |> Admin.create_changeset(created_by_user, workspace)
      |> Repo.insert!()

      workspace
    end)
  end

  def preload_channels(%Workspace{} = workspace) do
    Repo.preload(workspace, :channels)
  end

  @doc """
  Updates a workspace.

  ## Examples

      iex> update_workspace(workspace, %{field: new_value})
      {:ok, %Workspace{}}

      iex> update_workspace(workspace, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workspace(%Workspace{} = workspace, attrs) do
    workspace
    |> Workspace.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workspace.

  ## Examples

      iex> delete_workspace(workspace)
      {:ok, %Workspace{}}

      iex> delete_workspace(workspace)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workspace(%Workspace{} = workspace) do
    Repo.delete(workspace)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workspace changes.

  ## Examples

      iex> change_workspace(workspace)
      %Ecto.Changeset{source: %Workspace{}}

  """
  def change_workspace(%Workspace{} = workspace) do
    Workspace.changeset(workspace, %{})
  end

  @doc """
  Returns the list of channels.

  ## Examples

      iex> list_channels()
      [%Channel{}, ...]

  """
  def list_channels do
    Repo.all(Channel)
  end

  @doc """
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(123)
      %Channel{}

      iex> get_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(id), do: Repo.get!(Channel, id)

  @doc """
  Gets a single channel only if the user is a member of it.
  """
  def get_channel_with_subscriber(%User{} = user, channel_id) do
    from(c in Channel,
      join: u in assoc(c, :subscribers),
      where: c.id == ^channel_id and u.id == ^user.id
    )
    |> Repo.one()
  end

  @doc """
  Creates a channel.
  """
  # TODO verify both users are members of the workspace this channel is being
  # created in
  def create_channel(%{"type" => "direct"} = attrs) do
    workspace = Repo.get!(Workspace, Map.fetch!(attrs, "workspace_id"))
    to_user = Repo.get!(User, Map.fetch!(attrs, "to_user_id"))
    from_user = Repo.get!(User, Map.fetch!(attrs, "from_user_id"))

    cond do
      !Accounts.member?(to_user, workspace) ->
        {:error, :to_user_unauthorized}

      !Accounts.member?(from_user, workspace) ->
        {:error, :from_user_unauthorized}

      channel =
          Repo.one(
            from c in Channel,
              join: s1 in Subscription,
              on: [channel_id: c.id],
              join: s2 in Subscription,
              on: [channel_id: c.id],
              where:
                c.type == "direct" and c.workspace_id == ^workspace.id and
                  s1.user_id == ^to_user.id and s2.user_id == ^from_user.id
          ) ->
        {:error, :direct_channel_already_exists, channel.id}

      true ->
        Repo.transaction(fn ->
          channel =
            %Channel{}
            |> Channel.changeset(%{
              type: "direct",
              name: "#{from_user.username}_#{to_user.username}",
              description:
                "Direct messages between #{from_user.username} and #{to_user.username}",
              created_by_user_id: from_user.id,
              workspace_id: workspace.id
            })
            |> Repo.insert!()

          from_user_subscription =
            %Subscription{}
            |> Subscription.changeset(%{user_id: from_user.id, channel_id: channel.id})
            |> Repo.insert!()

          to_user_subscription =
            %Subscription{}
            |> Subscription.changeset(%{user_id: to_user.id, channel_id: channel.id})
            |> Repo.insert!()

          %{
            channel: channel,
            from_user_subscription: from_user_subscription,
            to_user_subscription: to_user_subscription
          }
        end)
    end
  end

  def create_channel(attrs) do
    workspace = Repo.get!(Workspace, Map.fetch!(attrs, "workspace_id"))
    created_by_user = Repo.get!(User, Map.fetch!(attrs, "created_by_user_id"))

    cond do
      !Accounts.member?(created_by_user, workspace) ->
        {:error, :created_by_user_unauthorized}

      true ->
        Repo.transaction(fn ->
          channel =
            %Channel{}
            |> Channel.changeset(attrs)
            |> Repo.insert!()

          subscription =
            %Subscription{}
            |> Subscription.changeset(%{user_id: created_by_user.id, channel_id: channel.id})
            |> Repo.insert!()

          %{channel: channel, subscription: subscription}
        end)
    end
  end

  @doc """
  Updates a channel.

  ## Examples

      iex> update_channel(channel, %{field: new_value})
      {:ok, %Channel{}}

      iex> update_channel(channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Channel.

  ## Examples

      iex> delete_channel(channel)
      {:ok, %Channel{}}

      iex> delete_channel(channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Examples

      iex> change_channel(channel)
      %Ecto.Changeset{source: %Channel{}}

  """
  def change_channel(%Channel{} = channel) do
    Channel.changeset(channel, %{})
  end

  @doc """
  Returns the most recent messages in a given channel.
  """
  def list_messages_in_channel(channel_id, opts \\ [limit: 15]) do
    Repo.all(
      from m in Message,
        where: m.channel_id == ^channel_id,
        preload: [:sent_by_user],
        limit: ^opts[:limit],
        order_by: [desc: m.inserted_at]
    )
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(sent_by_user_id, channel_id, attrs \\ %{}) do
    %Message{}
    |> Message.create_changeset(sent_by_user_id, channel_id, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  def list_public_channels(%Workspace{} = workspace) do
    Repo.all(
      from c in Channel,
        join: w in assoc(c, :workspace),
        where: w.id == ^workspace.id and c.type == "public"
    )
  end
end
