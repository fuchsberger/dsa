defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  def gravatar_url(user) do
    email = if is_nil(user), do: "unknown", else: user.email
    "https://s.gravatar.com/avatar/#{:erlang.md5(email) |> Base.encode16(case: :lower)}?s=32"
  end


end
