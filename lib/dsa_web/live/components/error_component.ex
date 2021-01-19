defmodule DsaWeb.ErrorComponent do
  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full space-y-8">
        <div>
          <img class="mx-auto h-12 w-auto" src="https://tailwindui.com/img/logos/workflow-mark-indigo-600.svg" alt="Workflow">
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Error 404
          </h2>
          <p class="mt-2 text-center text-gray-600">
            Die Seite existiert nicht!
          </p>
        </div>
      </div>
    </div>
    """
  end
end
