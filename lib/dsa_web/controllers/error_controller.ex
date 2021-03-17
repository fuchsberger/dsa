defmodule DsaWeb.ErrorController do
  use DsaWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_layout(false)
    |> put_flash(:error, gettext("You must authenticate to access the requested response."))
    |> put_status(:unauthorized)
    |> put_view(DsaWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :unconfirmed}) do
    conn
    |> put_layout(false)
    |> put_flash(:error, gettext("Account must be confirmed first. Please check your email."))
    |> put_status(:unauthorized)
    |> put_view(DsaWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> render(:"403")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(:"404")
  end

  def call(conn, {:error, :character_not_found}) do
    conn
    |> put_flash(:error, gettext("The given character was not found."))
    |> put_status(:not_found)
    |> put_layout(false)
    |> put_view(DsaWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_flash(:error, gettext("Invalid Login Data."))
    |> put_layout("flipped.html")
    |> render("new.html")
  end

  def call(conn, {:error, Ecto.NoResultsError}) do
    conn
    |> put_status(:not_found)
    |> render(:"404")
  end

  def call(conn, error) do
    Logger.error inspect error
    conn
    |> put_status(:internal_server_error)
    |> put_layout(false)
    |> put_view(DsaWeb.ErrorView)
    |> render(:"500")
  end

  # defp render_error(conn, status) do
  #   conn

  # end
end
