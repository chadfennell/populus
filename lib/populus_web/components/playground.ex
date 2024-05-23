defmodule Populus.Components.Playground do
  use Phoenix.Component

  attr :classifier, :map, required: true

  def playground(assigns) do
    ~H"""
    <h2 class="text-xl mb-3"><%= @classifier.title %></h2>
    <div class="flex items-start space-x-4">
      <div class="min-w-0 flex-1">
        <form id={"form-#{@classifier.type}"} phx-submit="classify" class="relative">
          <input type="hidden" name="type" value={@classifier.type} />
          <div class="overflow-hidden rounded-lg shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-indigo-600">
            <textarea
              rows="7"
              name="message"
              id="message"
              class="block w-full resize-none border-0 bg-transparent py-1.5 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
            ><%= @classifier.message %></textarea>
            <!-- Spacer element to match the height of the toolbar -->
            <div class="py-2" aria-hidden="true">
              <!-- Matches height of button in toolbar (1px border + 36px content height) -->
              <div class="py-px">
                <div class="h-9"></div>
              </div>
            </div>
          </div>

          <div class="absolute inset-x-0 bottom-0 flex justify-between py-2 pl-3 pr-2">
            <div class="flex-shrink-0">
              <button
                type="submit"
                class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                Post
              </button>
            </div>
          </div>
        </form>
      </div>

      <div class="min-w-0 flex-1">
        <div class="overflow-hidden rounded-lg shadow-sm ring-1 ring-inset ring-gray-300 focus-within:ring-2 focus-within:ring-indigo-600">
          <textarea
            rows="15"
            name="message_classified"
            id="message_classified"
            class="block w-full resize-none border-0 bg-transparent py-1.5 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
          >
        <%= @classifier.result %>
    </textarea>
        </div>
      </div>
    </div>
    """
  end
end
