module WashersHelper
  def next_step_link(washer)
    case washer.state

    when "available"
      link_to claim_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
        content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")

      end
      # polymorphic_url washer.becomes(Washer), action:"#{event[0].to_sym}", method: :patch


    when "empty"
      link_to fill_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
        content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")

      end
      
      link_to unclaim_washer_path(washer),method: :patch, class: 'btn btn-primary pull-xs-right' do
       content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")


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
  end
end
