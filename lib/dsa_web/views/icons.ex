defmodule DsaWeb.Icons do

  use Phoenix.HTML

  # Some icons are creative property of Font Awesome
  # Licenced under Attribution 4.0 International (CC by 4.0)
  # https://fontawesome.com/license/free

  @bell "M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"

  @check_square "M400 480H48c-27 0-48-21-48-48V80c0-27 21-48 48-48h352c27 0 48 21 48 48v352c0 27-21 48-48 48zm-205-98l184-184c7-6 7-16 0-23l-22-22c-7-7-17-7-23 0L184 303l-70-70c-6-7-16-7-23 0l-22 22c-7 7-7 17 0 23l104 104c6 6 16 6 22 0z"

  @plus_square "M352 240v32c0 7-5 12-12 12h-88v88c0 7-5 12-12 12h-32c-7 0-12-5-12-12v-88h-88c-7 0-12-5-12-12v-32c0-7 5-12 12-12h88v-88c0-7 5-12 12-12h32c7 0 12 5 12 12v88h88c7 0 12 5 12 12zm96-160v352c0 27-21 48-48 48H48c-26 0-48-21-48-48V80c0-26 22-48 48-48h352c27 0 48 22 48 48zm-48 346V86c0-3-3-6-6-6H54c-3 0-6 3-6 6v340c0 3 3 6 6 6h340c3 0 6-3 6-6z"

  @check_list "M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"

  @power_off "M400 54a248 248 0 11-288 0c11-8 28-5 35 8l16 28c5 11 3 24-7 31a168 168 0 10200 0c-10-7-13-21-7-31l16-28c7-13 23-16 35-8zM296 264V24c0-13-11-24-24-24h-32c-13 0-24 11-24 24v240c0 13 11 24 24 24h32c13 0 24-11 24-24z"


  defp path(d, opts \\ []) do
    tag :path,
      Keyword.merge([
        fill: "currentColor",
        d: d,
        stroke_linecap: "round",
        stroke_linejoin: "round",
        stroke_width: 2
      ], opts)
  end

  defp svg(paths, opts \\ []) do
    content_tag :svg, paths, Keyword.merge([
      area_hidden: true,
      class: "h-6 w-6",
      fill: "none",
      stroke: "currentColor",
      viewBox: "0 0 24 24"
    ], opts)
  end

  def icon(:toggle, active?) do
    svg (if active?, do: path(@check_square), else: path(@plus_square)),
      class: "inline-block w-6 h-5 #{if active?, do: "text-green-500", else: "text-gray-500"}",
      viewBox: "0 0 448 512"
  end

  def icon(:checklist) do
    svg path(@check_list, stroke_linecap: "round", fill: "none",  stroke_linejoin: "round", stroke_width: 2), class: "inline-block w-6 h-6", stroke: "currentColor", fill: "none", viewBox: "0 0 24 24"
  end

  def icon(:bell, opts), do: svg path(@bell), opts

  def icon(:power_off, opts), do: svg path(@power_off), opts
end
