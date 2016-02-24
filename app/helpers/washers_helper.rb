module WashersHelper


  def washer_list_item(washer)
    case washer.state
    when "available"
      content_tag :li, class:"washer list-group-item clearfix" do

        next_step_link(washer)
      end
    when "empty"
      content_tag :li, class:"washer list-group-item list-group-item-info clearfix" do
        next_step_link(washer)
      end
    when "unpaid"
      content_tag :li, class:"washer list-group-item list-group-item-warning clearfix" do
        next_step_link(washer)
      end
    when "ready"
      content_tag :li, class:"washer list-group-item list-group-item-warning clearfix" do
        next_step_link(washer)
      end
    when "in_progess"
      content_tag :li, class:"washer list-group-item list-group-item-success clearfix" do
        next_step_link(washer)
      end
    when "complete"
      content_tag :li, class:"washer list-group-item list-group-item-success clearfix" do
        next_step_link(washer)
      end


    end

  end
  def next_step_link(washer)
    capture do
      concat content_tag(:span, washer.position, class: "label label-primary")
      concat " "
      concat link_to "#{washer.name} (#{washer.state})", washer_path(washer)
      concat " "

      concat content_tag(:span, ctag(washer), class:"pull-right")

    end
  end
  def ctag(washer)
    capture do
      if can? :use, washer
        case washer.state

        when "available"
          link_to claim_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
            content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")

          end


        when "empty"
          capture do
            concat  link_to content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left"), unclaim_washer_path(washer), method: :patch, class: 'btn btn-primary pull-xs-right'
            concat " "
            concat link_to content_tag(:span, nil, class: "glyphicon glyphicon-download-alt"), fill_washer_path(washer), method: :patch, class: 'btn btn-primary pull-xs-right'
          end


        when "unpaid"
          link_to insert_coins_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
            content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")


          end
        when "ready"
          link_to start_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
            content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")


          end
        when "in_progess"
          link_to remove_clothes_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
            content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")


          end
        when "complete"
          link_to remove_clothes_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
            content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")


          end


        end
      else
        if washer.user
          content_tag(:p, "currently in use (#{washer.user.username})")
        else
          content_tag(:p, "currently in use (Guest)")


        end
      end

    end
  end
end
