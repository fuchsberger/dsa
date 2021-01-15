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
    Form.email_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def number_input(form, field, opts \\ []) do
    Form.number_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  defp border_class(form, field) do
    case is_nil(form.source.action) || not Keyword.has_key?(form.source.errors, field) do
      true -> "border-gray-300"
      false -> "border-red-700"
    end
  end

  def password_input(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.merge(Form.input_validations(form, field))
      |> Keyword.merge([
        class: "#{@base_classes} #{border_class(form, field)} #{@focus_classes} #{Keyword.get(opts, :class)}"
        ])

    Form.password_input(form, field, opts)
  end

  def text_input(form, field, opts \\ []) do
    Form.text_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def select(form, field, options, opts \\ []) do
    Form.select(form, field, options, Keyword.merge(Form.input_validations(form, field), opts))
  end

  @doc """
  Generates tag for inlined form input errors.
  It'll call a simple mock method to interpolate, as translations should be
  handled in the Phoenix app implementing Pow.
  """
  def error_tag(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(&error_tag/1)
  end

  def error_tag(error) do
    content_tag(:span, translate_error(error), class: "block text-sm text-red-700 text-bold text-center")
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
