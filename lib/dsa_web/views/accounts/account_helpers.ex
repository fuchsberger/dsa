defmodule DsaWeb.AccountHelpers do
  @moduledoc """
  Conveniences for account management views.
  """
  use Phoenix.HTML
  import DsaWeb.Gettext
  alias DsaWeb.Router.Helpers, as: Routes

  def account_alert(%Ecto.Changeset{action: action}) when not is_nil(action) do
    content_tag :div, dgettext("account", "Oops, something went wrong! Please check the errors below."), class: "inline-block alert error"
  end

  def account_alert(_), do: nil

  def account_link(conn, :delete_account) do
    link dgettext("account", "Delete Account"),
      to: Routes.user_settings_path(conn, :delete),
      method: :delete,
      data_confirm: dgettext("account", "Are you sure you want to delete your account including all characters?")
  end

  def account_link(conn, :settings) do
    link dgettext("account", "Settings"), to: Routes.user_settings_path(conn, :edit)
  end
end
