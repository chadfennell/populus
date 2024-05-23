defmodule Populus.Components.Forms do
  use Phoenix.Component
  import Flop.Phoenix
  import PopulusWeb.CoreComponents

  attr :value, :any, required: true
  attr :off_value, :any, required: true
  attr :active, :boolean, default: false
  attr :field, :string, required: true
  attr :on_icon, :string, default: ""
  attr :off_icon, :string, default: ""

  def filter_button(assigns) do
    %{field: field, on_value: on_value} = assigns

    assigns =
      assigns |> assign(active: "#{field.form.data.value}" == "#{on_value}")

    ~H"""
    <input
      type="hidden"
      id={"flop_filters_#{@field.id}_field"}
      name={"filters[#{@field.form.index}][field]"}
      value={@field.form.data.field}
    />

    <button
      :if={@active == false}
      type="submit"
      class="block mb-4 phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
    >
      <%= @on_text %>
      <.icon name={"hero-#{@on_icon}"} class="h-25 w-25 " />

      <input type="hidden" name={@field.name} value={@on_value} />
    </button>

    <button
      :if={@active}
      type="submit"
      class="block mb-4 phx-submit-loading:opacity-75 rounded-lg bg-zinc-700 hover:bg-zinc-900 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
    >
      <%= @off_text %>
      <.icon name={"hero-#{@off_icon}"} class="h-25 w-25 " />

      <input name={@field.name} type="hidden" value={@off_value} />
    </button>
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
              <.filter_button field={i.field} {i.rest} />
            <% _ -> %>
              <.input field={i.field} label={i.label} type={i.type} phx-debounce={120} {i.rest} />
          <% end %>
        </.filter_fields>
      </div>

      <%= render_slot(@inner_block, @form) %>

      <button
        class="hover:bg-zinc-800 hover:text-white border-2 border-zinc-300 rounded-lg p-2"
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
