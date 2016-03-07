class MachineDecorator < Draper::Decorator
  # class WasherDecorator < Draper::Decorator
  include Draper::LazyHelpers


  delegate_all
  decorates_finders
  # decorates_association :machine, :scope => :available_machines
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  # def object_list_item(object)
  def list_item_class
    if can? :use, object
      case object.state
      when "available"
        "object list-group-item clearfix"
      when "empty"
        "object list-group-item list-group-item-info clearfix"
      when "unpaid"
        "object list-group-item list-group-item-warning clearfix"
      when "ready"
        "object list-group-item list-group-item-warning clearfix"
      when "in_progess"
        "object list-group-item list-group-item-success clearfix"
      when "complete"
        "object list-group-item list-group-item-success clearfix"
      end
    else
      "object list-group-item disabled clearfix"
    end
  end
  def position_label
    content_tag(:span, object.position, class: "label label-primary")
  end
  def machine_link
    link_to "#{object.name} (#{object.state})", machine_path(object)
  end
  def next_step_link
  end
  def machine_info
    h.capture do
      concat machine_user
      concat machine_load
      concat machine_coins
      concat machine_period
    end
  end
  def machine_user
    content_tag(:li, "current user: #{machine.user.username}", class:"list-group-item ") unless machine.user == nil

  end
  def machine_coins
    content_tag(:li, "coin_count: #{machine.coins}/#{machine.price}", class:"list-group-item ")
  end
  def machine_time

  end
  def machine_period
    content_tag(:li, "this machine runs for #{machine.period} seconds", class:"list-group-item ")

  end
  def machine_load
    content_tag(:li, "current load: #{machine.load.name}", class:"list-group-item ") unless machine.load == nil
  end
  def event_path(event)
    case event
    when "claim"
      claim_machine_path(object)
    when "fill"
      fill_machine_path(object)
    when "unclaim"
      unclaim_machine_path(object)
    when "insert_coins"
      insert_coins_machine_path(object)
    when "start"
      start_machine_path(object)
    when "remove_clothes"
      remove_clothes_machine_path(object)
    end
  end
  def has_form_input(event)
    event == "fill" || event ==  "insert_coins"
  end
  def event_icon(event)
    case event
    when "claim"
      content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
    when "fill"
    when "unclaim"
      content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
      # when "insert_coins"
    when "start"
      content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
    when "remove_clothes"
      content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
    end
  end
  def event_form(step)
    case step
    when "fill"
      simple_form_for machine, url: fill_machine_path(machine), html: { class: "form-group form-inline"} do |f|
        concat f.input(:load, label: "choose load",  as: :select, collection: current_user.loads, label_method: :name, value_method: :id, wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'loadaa' })
        concat f.button :submit, "fill machine" ,method: :patch, class: ' btn btn-primary'
      end
    when "insert_coins"
      simple_form_for machine, url: insert_coins_machine_path(machine), html: { class: "form-group form-inline btn-group"} do |f|
        content_tag :div, class: "input-group select optional" do
          concat f.input(:coins, as: :select, collection: (1..machine.price),inline_label: "coin count", wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'count' } )
          concat f.button :submit, value: :insert_coins, method: :patch, class: ' form-inputs from-group-btn btn btn-primary'
        end
      end
    end
  end

  # end

end
