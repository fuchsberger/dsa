defmodule DsaWeb.FormHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML
  alias Phoenix.HTML.Form

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(DsaWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(DsaWeb.Gettext, "errors", msg, opts)
    end
  end

  def number_input(f, field, opts \\ []), do: Form.number_input(f, field, opts(f, field, opts))
  def text_input(f, field, opts \\ []), do: Form.text_input(f, field, opts(f, field, opts))

  def select(f, field, options, opts \\ []),
    do: Form.select(f, field, options, opts(f, field, opts, "form-select"))

  defp opts(f, field, opts, type \\ "form-control") do
    Keyword.put(opts, :class, "#{type} #{Keyword.get(opts, :class, "")}") ++ Form.input_validations(f, field)
  end
end
