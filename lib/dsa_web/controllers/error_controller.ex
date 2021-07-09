defmodule DsaWeb.ErrorController do
  use DsaWeb, :controller

  # def call(conn, {:error, :unauthorized}) do
  #   conn
  #   |> put_layout(false)
  #   |> put_flash(:error, gettext("You must authenticate to access the requested response."))
  #   |> put_status(:unauthorized)
  #   |> put_view(DsaWeb.ErrorView)
  #   |> render(:"401")
  # end

  # def call(conn, {:error, :unconfirmed}) do
  #   conn
  #   |> put_layout(false)
  #   |> put_flash(:error, gettext("Account must be confirmed first. Please check your email."))
  #   |> put_status(:unauthorized)
  #   |> put_view(DsaWeb.ErrorView)
  #   |> render(:"401")
  # end

  def call(conn, {:error, :forbidden}) do
    conn
    |> prepare_error_template()
    |> put_status(:forbidden)
    |> render(:"403")
  end

  # def call(conn, {:error, :not_found}) do
  #   conn
  #   |> put_status(:not_found)
  #   |> render(:"404")
  # end

  def call(conn, {:error, :character_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_flash(:error, gettext("Der Held wurde nicht gefunden."))
    |> prepare_error_template()
    |> render(:"404")
  end

  # def call(conn, {:error, :invalid_credentials}) do
  #   conn
  #   |> put_flash(:error, gettext("Invalid Login Data."))
  #   |> render("new.html")
  # end

  # def call(conn, {:error, Ecto.NoResultsError}) do
  #   conn
  #   |> prepare_error_template()
  #   |> put_status(:not_found)
  #   |> render(:"404")
  # end

  @doc """
  Unknown error fallback.
  """
  # def call(conn, error) do
  #   Logger.error inspect error
  #   conn
  #   |> prepare_error_template()
  #   |> put_status(:internal_server_error)
  #   |> render(:"500")
  # end

  defp prepare_error_template(conn) do
    conn
    |> put_layout(false)
    |> put_view(DsaWeb.ErrorView)
  end
end
