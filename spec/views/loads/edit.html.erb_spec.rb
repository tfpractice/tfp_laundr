require 'rails_helper'

RSpec.describe "loads/edit", type: :view do
  before(:each) do
    @load = assign(:load, Load.create!(
      :weight => "9.99",
      :state => "MyString",
      :user => nil,
      :machine => nil
    ))
  end

  it "renders the edit load form" do
    render

    assert_select "form[action=?][method=?]", load_path(@load), "post" do

      assert_select "input#load_weight[name=?]", "load[weight]"

      assert_select "input#load_state[name=?]", "load[state]"

      assert_select "input#load_user_id[name=?]", "load[user_id]"

      assert_select "input#load_machine_id[name=?]", "load[machine_id]"
    end
  end
end
