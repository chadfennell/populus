defmodule Populus.Components.Forms do
  use Phoenix.Component
  import Flop.Phoenix
  import PopulusWeb.CoreComponents

    @doc """
    A functional component that renders a toggle button.
    """
    attr :field, :map, required: true
    attr :value, :any, required: true
    attr :label, :any, required: true

    attr :active, :boolean, default: false

    def filter_button(assigns) do

      %{field: field, value: value} = assigns

      assigns =
        assigns |> assign(active: "#{field.form.data.value}" == "#{value}")

      ~H"""
      <label for={"flop_filters_#{@field.id}_toggle"}><%= @label %></label>
      <div class="relative inline-flex h-6 w-11">
        <input
          type="checkbox"
          id={"flop_filters_#{@field.id}_toggle"}
          name={@field.name}
          value={@value}
          checked={@active}
          class="sr-only"
        />
        <label
          for={"flop_filters_#{@field.id}_toggle"}
          class="bg-gray-200 rounded-full transition-colors duration-200 ease-in-out cursor-pointer w-full h-full flex items-center border-2 border-transparent focus-within:ring-2 focus-within:ring-indigo-600 focus-within:ring-offset-2"
        >
          <span class={"inline-block h-5 w-5 bg-white rounded-full shadow transform transition-transform duration-200 ease-in-out #{if @active, do: "translate-x-5", else: "translate-x-0"}"}>
          </span>
        </label>
      </div>
      """
    end

  attr :fields, :list, required: true
  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string, default: "update-filter"

  attr :target, :string, default: nil
  slot :inner_block, required: false

  def filter_form(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <.form for={@form} id={@id} phx-target={@target} phx-change={@on_change} phx-submit={@on_change}>
      <div class="grid grid-row gap-4">
        <.filter_fields :let={i} form={@form} fields={@fields}>
          <%= case i.type do %>
            <% "button" -> %>
              <.filter_button field={i.field} label={i.label} {i.rest} />
            <% _ -> %>
              <.input field={i.field} label={i.label} type={i.type} phx-debounce={120} {i.rest} />
          <% end %>
        </.filter_fields>
      </div>

      <%= render_slot(@inner_block, @form) %>

      <button
        class="mt-5 hover:bg-zinc-800 hover:text-white border-2 border-zinc-300 rounded-lg p-2"
        name="reset"
      >
        Reset Filters
      </button>
    </.form>
    """
  end

  def pagination_opts do
    [
      ellipsis_attrs: [class: "ellipsis"],
      ellipsis_content: "‥",
      next_link_attrs: [class: "next"],
      next_link_content: next_icon(),
      page_links: {:ellipsis, 7},
      pagination_link_aria_label: &"#{&1}ページ目へ",
      previous_link_attrs: [class: "prev"],
      previous_link_content: previous_icon()
    ]
  end

  defp next_icon do
    assigns = %{}

    ~H"""
    <i class="fas fa-chevron-right" />
    """
  end

  defp previous_icon do
    assigns = %{}

    ~H"""
    <i class="fas fa-chevron-left" />
    """
  end

  def table_opts do
    [
      container: true,
      container_attrs: [class: "table-container"],
      no_results_content: no_results_content(),
      table_attrs: [class: "table"]
    ]
  end

  defp no_results_content do
    assigns = %{}

    ~H"""
    <p>Nothing found.</p>
    """
  end
end
