# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Snickr.Repo.insert!(%Snickr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Snickr.Repo
alias Snickr.Accounts.{User, Membership, Subscription, Admin}
alias Snickr.Platform.{Workspace, Channel, Message}

import Ecto.Query, only: [from: 2]

Faker.start()
# Faker uses :rand as its random number generator module
:rand.seed(:exs64, {1, 1, 1})

for _ <- 1..10 do
  u = %User{
    first_name: Faker.Name.first_name(),
    last_name: Faker.Name.last_name(),
    password_hash: Faker.String.base64(32)
  }

  u = %{
    u
    | username:
        "#{String.first(u.first_name) |> String.downcase()}#{String.downcase(u.last_name)}"
  }

  u = %{u | email: "#{u.username}@#{Faker.Internet.domain_name()}"}
  Repo.insert!(u)
end

for _ <- 1..4 do
  u = Repo.get!(User, Enum.random(1..3))

  w = %Workspace{
    # Up to 3 users will create workspaces
    created_by_user: u,
    name: "Team #{Faker.Pokemon.name()}"
  }

  w = %{w | description: "The official workspace for #{w.name}"}
  {ok, w} = Repo.insert(w)
  # The user who created the workspace is created as a member and an
  # administrator of the channel
  Repo.insert!(%Membership{workspace: w, user: u})
  Repo.insert!(%Admin{workspace: w, user: u})
end

for w <- Repo.all(from w in Workspace, preload: :created_by_user) do
  # There is at least one public channel per workspace
  c = %Channel{
    name: "announcements",
    description: "For general announcements to the entire team",
    type: "public",
    created_by_user: w.created_by_user,
    workspace: w
  }

  {:ok, c} = Repo.insert(c, returning: true)
  Repo.insert!(%Subscription{channel: c, user: w.created_by_user})
end

# Add each user to two workspaces and one channel in each workspace
for u <- Repo.all(User) do
  for _ <- 1..2 do
    w = Repo.all(Workspace) |> Enum.random()
    Repo.insert!(%Membership{workspace: w, user: u}, on_conflict: :nothing)

    query = from c in Channel, where: c.workspace_id == ^w.id

    c = Repo.all(query) |> Enum.random()
    Repo.insert!(%Subscription{channel: c, user: u}, on_conflict: :nothing)
  end
end

# Create one direct message channel per workspace between two random users
for w <- Repo.all(Workspace) do
  query =
    from m in "memberships",
      select: m.user_id,
      where: m.workspace_id == ^w.id,
      limit: 2

  [user_id_1, user_id_2] = Repo.all(query)
  user_1 = Repo.get(User, user_id_1)
  user_2 = Repo.get(User, user_id_2)

  c = %Channel{
    workspace_id: w.id,
    name: "#{user_1.username}_#{user_2.username}",
    description: "Direct messages between #{user_1.username} and #{user_2.username}",
    # Assume the first user initiated the direct message
    created_by_user: user_1,
    type: "direct"
  }

  {:ok, c} = Repo.insert(c)
  s_1 = %Subscription{channel: c, user: user_1}
  s_2 = %Subscription{channel: c, user: user_2}
  Repo.insert!(s_1)
  Repo.insert!(s_2)
end

# Send one message in each channel by a user subscribed to that channel
for c <- Repo.all(Channel) do
  query =
    from s in "subscriptions",
      select: s.user_id,
      where: s.channel_id == ^c.id

  user_id = Repo.all(query) |> Enum.random()
  u = Repo.get!(User, user_id)
  # This shows that a user can send multiple messages to the same channel
  # very quickly and not cause a constraint failure on inserted_at
  for _ <- 1..2 do
    Repo.insert!(%Message{
      channel: c,
      sent_by_user: u,
      content: Faker.StarWars.quote()
    })

    Process.sleep(5)
  end
end
