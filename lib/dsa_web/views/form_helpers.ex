defmodule DsaWeb.FormHelpers do
  @moduledoc """
  Conveniences for translating and building forms, inputs, and error messages.
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form

  require Logger

  @base_classes " placeholder-gray-500 text-gray-900"
  @focus_classes "focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10"

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

  defp expand(form, field, opts) do
    error_class =
      case is_nil(form.source) || is_nil(form.source.action) || not Keyword.has_key?(form.source.errors, field) do
        true -> ""
        false -> " error"
      end

    opts
    |> Keyword.merge(Form.input_validations(form, field))
    |> Keyword.merge([class: "#{Keyword.get(opts, :class)}#{error_class}"])
  end

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
