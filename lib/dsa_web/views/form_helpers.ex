defmodule DsaWeb.FormHelpers do
  @moduledoc """
  Conveniences for translating and building forms, inputs, and error messages.
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form

  # Add HTML5 validations to fields

  def email_input(form, field, opts \\ []) do
    Form.email_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def number_input(form, field, opts \\ []) do
    Form.number_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def password_input(form, field, opts \\ []) do
    Form.password_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def text_input(form, field, opts \\ []) do
    Form.text_input(form, field, Keyword.merge(Form.input_validations(form, field), opts))
  end

  def select(form, field, options, opts \\ []) do
    Form.select(form, field, options, Keyword.merge(Form.input_validations(form, field), opts))
  end
end
