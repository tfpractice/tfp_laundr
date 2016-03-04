class WasherDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  decorates_finders

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
  def washer_link
    link_to "#{object.name} (#{object.state})", washer_path(object)

  end
  def next_step_link

    # concat " "
    # concat " "

    content_tag(:span, ctag, class:"pull-right")
    # concat content_tag(:span, object.position, class: "label label-primary")
    # concat " "
    # concat link_to "#{object.name} (#{object.state})", washer_path(object)
    # concat " "

    # concat content_tag(:span, ctag, class:"pull-right")

    # end
  end
  def event_path(event)
    case event
    when "claim"
      claim_washer_path(object)
    when "fill"
      fill_washer_path(object)

    when "unclaim"
      unclaim_washer_path(object)

    when "insert_coins"
      insert_coins_washer_path(object)

    when "start"
      start_washer_path(object)

    when "remove_clothes"
      remove_clothes_washer_path(object)

    end
  end

  def has_form_input(event)

    event == ("fill" || "insert_coins")

  end

  def event_icon(event)
    case event
    when "claim"
      content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
    when "fill"
      # event_form(event)
      # content_tag(:span, nil, class: "glyphicon glyphicon-download-alt")
    when "unclaim"
      content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
    when "insert_coins"
      content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")

    when "start"
      content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")

    when "remove_clothes"
      content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")

    end
  end

  def event_form(step)
    case step
    when "fill"
      # simple_form_for washer, :method => :patch,  url: fill_washer_path(washer), :html => {  :class => "pull-right form-inline", :method => :patch }do |f|
      form_for washer, url: fill_washer_path(washer), class: " pull-right form-inline" do |f|
        # concat f.input(:load,input_html: { name: 'load', class: "col-md-8" }, collection: Load.all, label_method: :weight, value_method: :id, name: "load")
        concat select_tag(:load, options_from_collection_for_select(Load.all, "id", "weight"), class:"pull-right", id: "washer#{washer.id}Load")
        concat  f.submit "fill with load", method: :patch, class: 'pull-right btn btn-primary'
      end
      #select_tag(:load, options_from_collection_for_select(Load.all, "id", "weight"), id: "washer#{washer.id}Load")
    when "insert_coins"
      select_tag :count, options_for_select((4..15).step(0.5))


    end

  end
  # def object.ctag
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

# end
