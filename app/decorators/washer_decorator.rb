class WasherDecorator < MachineDecorator
  include Draper::LazyHelpers

  decorates :washer
  delegate_all
  decorates_finders
  # decorates_association :washer, :scope => :available_machines
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  # def object_list_item(object)
  # def list_item_class
  # if can? :use, object
  #   case object.state
  #   when "available"
  #     "object list-group-item clearfix"
  #   when "empty"
  #     "object list-group-item list-group-item-info clearfix"
  #   when "unpaid"
  #     "object list-group-item list-group-item-warning clearfix"
  #   when "ready"
  #     "object list-group-item list-group-item-warning clearfix"
  #   when "in_progess"
  #     "object list-group-item list-group-item-success clearfix"
  #   when "complete"
  #     "object list-group-item list-group-item-success clearfix"
  #   end
  # else
  #   "object list-group-item disabled clearfix"
  # end
  # end
  # def position_label
  #   content_tag(:span, object.position, class: "label label-primary")
  # end
  # def washer_link
  #   link_to "#{object.name} (#{object.state})", washer_path(object)
  # end
  # def next_step_link
  # end
  # def washer_info
  #   washer_user
  #   washer_load
  # end
  def washer_user
    "current user: #{washer.user.username}" unless washer.user == nil

  end
  def washer_load
    "current load: #{washer.load.name}"  unless washer.load == nil


  end
  #def event_path(event)
  #  case event
  #  when "claim"
  #    claim_washer_path(object)
  #  when "fill"
  #    fill_washer_path(object)
  #  when "unclaim"
  #    unclaim_washer_path(object)
  #  when "insert_coins"
  #    insert_coins_washer_path(object)
  #  when "start"
  #    start_washer_path(object)
  #  when "remove_clothes"
  #    remove_clothes_washer_path(object)
  #  end
  #end
  # def has_form_input(event)
  #   event == "fill" || event ==  "insert_coins"
  # end
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
      simple_form_for washer, url: fill_washer_path(washer), html: { class: "  form-group form-inline  btn-group"} do |f|
        concat f.input(:load, as: :select, collection: Load.all, inline_label: "choose load" , label_method: :name, value_method: :id, wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'load' })
        concat f.button :submit, "fill machine" ,method: :patch, class: ' btn btn-primary'
        # concat button_tag link_icon do
        #   # f.button_tag
        #    link_icon
        #   concat "hello"
        # end
      end
    when "insert_coins"
      # wrapper_html:{class: "input-group"},
      simple_form_for washer, url: insert_coins_washer_path(washer), html: { class: "form-group form-inline btn-group"} do |f|
        content_tag :div, class: "input-group select optional" do
          concat f.input(:coins, as: :select, collection: (1..washer.price),inline_label: "coin count", wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'count' } )
          concat f.button :submit, value: :insert_coins, method: :patch, class: ' form-inputs from-group-btn btn btn-primary'
        end
      end
    end
  end
  def ctag
    # capture do
    if can? :use, object
      case object.state
      when "available"
        link_to claim_washer_path(object),method: :patch, class: 'btn btn-primary pull-xs-right' do
          content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        end
      when "empty"
        h.capture do
          concat  link_to content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left"), unclaim_washer_path(object), method: :patch, class: 'btn btn-primary pull-xs-right'
          concat " "
          concat link_to content_tag(:span, nil, class: "glyphicon glyphicon-download-alt"), fill_washer_path(object), method: :patch, class: 'btn btn-primary pull-xs-right'
        end
      when "unpaid"
        link_to insert_coins_washer_path(object),method: :patch, class: 'btn btn-primary pull-xs-right' do
          content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        end
      when "ready"
        link_to start_washer_path(object),method: :patch, class: 'btn btn-primary pull-xs-right' do
          content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        end
      when "in_progess"
        link_to remove_clothes_washer_path(object),method: :patch, class: 'btn btn-primary pull-xs-right' do
          content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        end
      when "complete"
        link_to remove_clothes_washer_path(object),method: :patch, class: 'btn btn-primary pull-xs-right' do
          content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        end
      end
    else
      if object.user
        content_tag(:p, "currently in use (#{object.user.username})")
      else
        content_tag(:p, "currently in use (Guest)")
      end
    end
  end
end
