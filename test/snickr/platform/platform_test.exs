defmodule Snickr.PlatformTest do
  use Snickr.DataCase

  alias Snickr.Platform

  describe "workspaces" do
    alias Snickr.Platform.Workspace

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    @tag :skip
    def workspace_fixture(attrs \\ %{}) do
      {:ok, workspace} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Platform.create_workspace()

      workspace
    end

    @tag :skip
    test "list_workspaces/0 returns all workspaces" do
      workspace = workspace_fixture()
      assert Platform.list_workspaces() == [workspace]
    end

    @tag :skip
    test "get_workspace!/1 returns the workspace with given id" do
      workspace = workspace_fixture()
      assert Platform.get_workspace!(workspace.id) == workspace
    end

    @tag :skip
    test "create_workspace/1 with valid data creates a workspace" do
      assert {:ok, %Workspace{} = workspace} = Platform.create_workspace(@valid_attrs)
      assert workspace.description == "some description"
      assert workspace.name == "some name"
    end

    @tag :skip
    test "create_workspace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Platform.create_workspace(@invalid_attrs)
    end

    @tag :skip
    test "update_workspace/2 with valid data updates the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{} = workspace} = Platform.update_workspace(workspace, @update_attrs)
      assert workspace.description == "some updated description"
      assert workspace.name == "some updated name"
    end

    @tag :skip
    test "update_workspace/2 with invalid data returns error changeset" do
      workspace = workspace_fixture()
      assert {:error, %Ecto.Changeset{}} = Platform.update_workspace(workspace, @invalid_attrs)
      assert workspace == Platform.get_workspace!(workspace.id)
    end

    @tag :skip
    test "delete_workspace/1 deletes the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{}} = Platform.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Platform.get_workspace!(workspace.id) end
    end

    @tag :skip
    test "change_workspace/1 returns a workspace changeset" do
      workspace = workspace_fixture()
      assert %Ecto.Changeset{} = Platform.change_workspace(workspace)
    end
  end

  describe "channels" do
    alias Snickr.Platform.Channel

    @valid_attrs %{description: "some description", name: "some name", type: "some type"}
    @update_attrs %{description: "some updated description", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{description: nil, name: nil, type: nil}

    def channel_fixture(attrs \\ %{}) do
      {:ok, channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Platform.create_channel()

      channel
    end

    @tag :skip
    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Platform.list_channels() == [channel]
    end

    @tag :skip
    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Platform.get_channel!(channel.id) == channel
    end

    @tag :skip
    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} = Platform.create_channel(@valid_attrs)
      assert channel.description == "some description"
      assert channel.name == "some name"
      assert channel.type == "some type"
    end

    @tag :skip
    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Platform.create_channel(@invalid_attrs)
    end

    @tag :skip
    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{} = channel} = Platform.update_channel(channel, @update_attrs)
      assert channel.description == "some updated description"
      assert channel.name == "some updated name"
      assert channel.type == "some updated type"
    end

    @tag :skip
    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Platform.update_channel(channel, @invalid_attrs)
      assert channel == Platform.get_channel!(channel.id)
    end

    @tag :skip
    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Platform.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Platform.get_channel!(channel.id) end
    end

    @tag :skip
    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Platform.change_channel(channel)
    end
  end

  describe "messages" do
    alias Snickr.Platform.Message

    @valid_attrs %{content: "some content", edited: true}
    @update_attrs %{content: "some updated content", edited: false}
    @invalid_attrs %{content: nil, edited: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Platform.create_message()

      message
    end

    @tag :skip
    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Platform.list_messages() == [message]
    end

    @tag :skip
    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Platform.get_message!(message.id) == message
    end

    @tag :skip
    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Platform.create_message(@valid_attrs)
      assert message.content == "some content"
      assert message.edited == true
    end

    @tag :skip
    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Platform.create_message(@invalid_attrs)
    end

    @tag :skip
    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Platform.update_message(message, @update_attrs)
      assert message.content == "some updated content"
      assert message.edited == false
    end

    @tag :skip
    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Platform.update_message(message, @invalid_attrs)
      assert message == Platform.get_message!(message.id)
    end

    @tag :skip
    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Platform.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Platform.get_message!(message.id) end
    end

    @tag :skip
    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Platform.change_message(message)
    end
  end
end
