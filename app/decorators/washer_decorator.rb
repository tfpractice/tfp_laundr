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
  def washer_list_item
    # capture do
    if can? :use, object
      case object.state
      when "available"
        content_tag :li, class:"object list-group-item clearfix" do

        next_step_link        end
      when "empty"
        content_tag :li, class:"object list-group-item list-group-item-info clearfix" do
        next_step_link          end
      when "unpaid"
        content_tag :li, class:"object list-group-item list-group-item-warning clearfix" do
        next_step_link          end
      when "ready"
        content_tag :li, class:"object list-group-item list-group-item-warning clearfix" do
        next_step_link          end
      when "in_progess"
        content_tag :li, class:"object list-group-item list-group-item-success clearfix" do
        next_step_link          end
      when "complete"
        content_tag :li, class:"object list-group-item list-group-item-success clearfix" do
        next_step_link          end

      end

    else
      content_tag :li, class:"object list-group-item disabled clearfix" do

      next_step_link        end
    end


    # end

  end
  # def next_step_link
  def next_step_link
    # capture do
    concat content_tag(:span, object.position, class: "label label-primary")
    concat " "
    concat link_to "#{object.name} (#{object.state})", washer_path(object)
    concat " "

    concat content_tag(:span, ctag, class:"pull-right")
    # concat content_tag(:span, object.position, class: "label label-primary")
    # concat " "
    # concat link_to "#{object.name} (#{object.state})", washer_path(object)
    # concat " "

    # concat content_tag(:span, ctag, class:"pull-right")

    # end
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

    # end
  end

end
