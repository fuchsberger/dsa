defmodule DsaWeb.SkillView do
  use DsaWeb, :view

  # alias Dsa.Type.SkillCategory

  defp skill_level(form, skill_id) do
    Map.get(form.data.data.skills, String.to_atom("skill_#{skill_id}"))
  end

  # def be_options do
  #   [
  #     {gettext("Event."), nil},
  #     {gettext("Ja"), true},
  #     {gettext("Nein"), false}
  #   ]
  # end

  # def probe_defaults(form) do
  #   case input_value(form, :probe) do
  #     {t1, t2, t3} -> {t1, t2, t3}
  #     nil -> {0, 0, 0}
  #   end
  # end
end
