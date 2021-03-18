defmodule DsaWeb.FormHelpers do
  @moduledoc """
  Conveniences for translating and building forms, inputs, and error messages.
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form

  import DsaWeb.Gettext

  require Logger

  # Add HTML5 validations to fields

  def email_input(form, field, opts \\ []) do
    Form.email_input(form, field, expand(form, field, opts))
  end

  def number_input(form, field, opts \\ []) do
    Form.number_input(form, field, expand(form, field, opts))
  end

  def password_input(form, field, opts) do
    Form.password_input(form, field, expand(form, field, opts))
  end

  def text_input(form, field, opts \\ []) do
    Form.text_input(form, field, expand(form, field, opts))
  end

  def select(form, field, options, opts \\ []) do
    Form.select(form, field, options, expand(form, field, opts))
  end

  def submit_button_text(changeset) do
    Logger.warn inspect changeset.data
    if is_nil(changeset.data.id), do: gettext("Create"), else: gettext("Update")
  end

  def submit_button(modified?) do
    text =
      case modified? do
        nil -> "Unverändert..."
        true -> "Speichern"
        false -> "Gespeichert"
      end

    submit text,
      class: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white focus:outline-none #{if modified?, do: "bg-indigo-600 hover:bg-indigo-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", else: "bg-indigo-200 text-indigo-500 cursor-not-allowed"}",
      disabled: is_nil(modified?) || not modified?
  end

  defp expand(%{source: source} = form, field, opts) when is_map(source) do

    error_class =
      case not Map.has_key?(form.source, :action) || is_nil(form.source.action) || not Keyword.has_key?(form.source.errors, field) do
        true -> ""
        false -> " error"
      end

    opts
    |> Keyword.merge(Form.input_validations(form, field))
    |> Keyword.merge([class: "#{Keyword.get(opts, :class)}#{error_class}"])
  end

  defp expand(_form, _field, opts), do: opts

  @doc """
  Generates tag for inlined form input errors.
  It'll call a simple mock method to interpolate, as translations should be
  handled in the Phoenix app implementing Pow.
  """
  def error_tag(form, field, opt_classes \\ "") do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(& error_div(&1, opt_classes))
  end

  def error_div(error, opt_classes) do
    content_tag(:div, translate_error(error), class: "text-sm text-red-700 text-bold #{opt_classes}")
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, msg ->
      token = "%{#{key}}"

      case String.contains?(msg, token) do
        true  -> String.replace(msg, token, to_string(value), global: false)
        false -> msg
      end
    end)
  end
end
