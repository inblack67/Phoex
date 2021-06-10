defmodule PhoexWeb.RoomController do
  use PhoexWeb, :controller
  alias Phoex.Talk.Room
  alias Phoex.Talk.TalkRepo

  def index(conn, _params) do
    rooms = TalkRepo.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    # empty map (second arg) => will be populated by the form
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # look for room map => bind that to room_input
  # every handler needs to retun the conn
  def create(conn, %{"room" => room_input}) do
    case TalkRepo.create_room(room_input) do
      {:ok, _room} ->
        conn
        |> put_flash(:info, "Room created")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = TalkRepo.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = TalkRepo.get_room!(id)
    changeset = TalkRepo.room_changeset(room)
    render(conn, "edit.html", changeset: changeset)
    # render(conn, "new.html", changeset: changeset))
  end

  def update(conn, %{"id" => id, "room" => room_input}) do
    room = TalkRepo.get_room!(id)

    case(TalkRepo.update_room(room, room_input)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room updated")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end
end
