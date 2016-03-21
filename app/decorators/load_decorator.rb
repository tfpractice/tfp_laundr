class LoadDecorator < Draper::Decorator
  include Draper::LazyHelpers

  decorates :load
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
  # lass
  # dirty
  # in_washer
  # washed
  # wet
  # in_dryer
  # dried
  # folded
  # clean
  def list_item_class
    if can? :handle, object
      case object.state
      when "dirty"
        "object list-group-item clearfix"
      when "in_washer"
        "object list-group-item list-group-item-info clearfix"
      when "washed"
        "object list-group-item list-group-item-warning clearfix"
      when "wet"
        "object list-group-item list-group-item-warning clearfix"
      when "in_dryer"
        "object list-group-item list-group-item-success clearfix"
      when "dried"
        "object list-group-item list-group-item-success clearfix"

      when "clean"
        "object list-group-item list-group-item-success clearfix"

      else
        "object list-group-item disabled clearfix"
      end
    end
    def position_label
      content_tag(:span, load.position, class: "label label-primary")
    end
    def load_link
      link_to "#{object.name} (#{object.state})", polymorphic_path(object)
    end
    def can_merge
      current_user.loads.same_state(load)

    end
    def next_step_link
    end
    def load_info
      h.capture do
        concat load_user
        concat load_machine
        concat load_weight
        concat load_dry_time
      end
    end
    def load_user
      content_tag(:li, "current user: #{load.user.username}", class:"list-group-item ") unless load.user == nil

    end
    def load_weight
      content_tag(:li, "load weight: #{load.weight}lbs.", class:"list-group-item ")
    end
    def load_time

    end
    def load_dry_time
      content_tag(:li, "this load runs for #{load.dry_time} seconds", class:"list-group-item ")

    end
    def load_machine
      content_tag(:li, "current load: #{load.machine.name}", class:"list-group-item ") unless load.machine == nil
    end
    def event_path(event)
      # return_coins
      # case event
      # when "insert"
      #   polymorphic_path(load, action: :insert)
      # when "merge"
      #   polymorphic_path(load, action: :insert)
      # when "remove_from_machine"
      # polymorphic_path(load, action: :remove_from_machine)
      # when "insert_coins"
      # polymorphic_path(load, action: :insert_coins)
      # when "return_coins"
      # polymorphic_path(load, action: :return_coins)
      # when "wash"
      #   polymorphic_path(load, action: :wash)
      # when "remove_clothes"
      #   polymorphic_path(load, action: :remove_clothes)
      # end
      # end

    end
    def has_form_input(event)
      event == "merge"
    end
    def event_icon(event)
      case event
      when "insert"
        content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        # when "insert"
      when "remove_from_machine"
        content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
        # when "insert_coins"
      when "dry"
        content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
      when "wash"
        content_tag(:span, nil, class: "glyphicon glyphicon-hand-right")
        # when "remove_clothes"
        # content_tag(:span, nil, class: "glyphicon glyphicon-chevron-left")
      end
    end
    def event_form(step)
      case step
      # when "insert"
      # "inset"
      # simple_form_for object, url: polymorphic_path(load, action: :insert), html: { class: "form-group form-inline btn-group"} do |f|
      # concat f.input(:machine, inline_label: "choose load",  as: :select, collection: (Washer.all), label_method: :name, value_method: :id, wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'machine' })
      # concat f.button :submit, "insert load" ,method: :patch, class: ' btn btn-primary'
      # end
      when "merge"
        # "merge"
        simple_form_for load, url: polymorphic_path(load, action: :merge), html: { class: "form-group form-inline btn-group"} do |f|
          # content_tag :div, class: "input-group select optional" do
          concat f.input(:merge, as: :select, collection: can_merge ,label_method: :name, value_method: :id,inline_label: "merge load", wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'mergeLoad' } )
          concat f.button :submit, value: :merge, method: :patch, class: ' form-inputs from-group-btn btn btn-primary'
        end
        # end
      end
    end

  end

end
