class DryerDecorator < MachineDecorator
  delegate_all

  def machine_period
    content_tag(:li, "this machine runs for 5 seconds for every coin inserted", class:"list-group-item ")

  end
  def event_form(step)
    case step
    when "fill"
      simple_form_for machine, url: fill_machine_path(machine), html: { class: "form-group form-inline  btn-group"} do |f|
        concat f.input(:load, as: :select, collection: machine.user.loads, label: "choose load" , label_method: :name, value_method: :id, wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'load' })
        concat f.button :submit, "fill dryer" ,method: :patch, class: ' form-inputs from-group-btn btn btn-primary'
      end
    when "insert_coins"
      simple_form_for machine, url: insert_coins_machine_path(machine), html: { class: "form-group form-inline btn-group"} do |f|
        concat f.input(:coins, as: :select, collection: (1..machine.user.coins),inline_label: "coin count", wrapper_html:{class: "input-group"},label_html: { class: 'input-group-addon' }, input_html: { name: 'count' } )
        concat f.button :submit, value: :insert_coins, method: :patch, class: ' form-inputs from-group-btn btn btn-primary'

      end
    end
  end

end
