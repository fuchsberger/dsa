defmodule DsaWeb.ErrorView do
  use DsaWeb, :view

  import DsaWeb.LayoutView, only: [title: 0, description: 0]

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  defp detailed_path(conn) do
    "#{conn.method} /#{Enum.join(conn.path_info, "/")}"
  end

  defp back_link(conn)  do
    link gettext("zurück zum DSA Tool"),
      class: "block link", to: Routes.page_path(conn, :index)
  end
end
