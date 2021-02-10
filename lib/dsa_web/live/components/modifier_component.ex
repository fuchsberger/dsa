defmodule DsaWeb.ModifierComponent do

  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class='grid grid-cols-4 md:grid-cols-8 pb-3 gap-4 font-bold text-sm leading-6'>

      <h3 class='leading-6 border-2 border-transparent'>Modifier</h3>

      <div class="col-span-3 grid grid-cols-6 text-sm text-center font-medium">
        <button class='<%= class(@mod, -6) %>' phx-click='set' phx-value-mod='-6'>-6</button>
        <button class='<%= class(@mod, -5) %>' phx-click='set' phx-value-mod='-5'>-5</button>
        <button class='<%= class(@mod, -4) %>' phx-click='set' phx-value-mod='-4'>-4</button>
        <button class='<%= class(@mod, -3) %>' phx-click='set' phx-value-mod='-3'>-3</button>
        <button class='<%= class(@mod, -2) %>' phx-click='set' phx-value-mod='-2'>-2</button>
        <button class='<%= class(@mod, -1) %>' phx-click='set' phx-value-mod='-1'>-1</button>
      </div>

      <button class='<%= class(@mod, 0) %>' phx-click='set' phx-value-mod='0'>0</button>

      <div class="col-span-3 grid grid-cols-6 text-sm font-medium">
        <button class='<%= class(@mod, 1) %>' phx-click='set' phx-value-mod='1'>1</button>
        <button class='<%= class(@mod, 2) %>' phx-click='set' phx-value-mod='2'>2</button>
        <button class='<%= class(@mod, 3) %>' phx-click='set' phx-value-mod='3'>3</button>
        <button class='<%= class(@mod, 4) %>' phx-click='set' phx-value-mod='4'>4</button>
        <button class='<%= class(@mod, 5) %>' phx-click='set' phx-value-mod='5'>5</button>
        <button class='<%= class(@mod, 6) %>' phx-click='set' phx-value-mod='6'>6</button>
      </div>
    </div>
    """
  end

  defp class(modifier, value) do
    base =
      cond do
        value > 0 -> "positive"
        value < 0 -> "negative"
        true -> "neutral"
      end

    if modifier == value, do: "#{base} active", else: base
  end
end
