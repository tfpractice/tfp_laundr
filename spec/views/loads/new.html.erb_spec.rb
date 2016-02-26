require 'rails_helper'

RSpec.describe "loads/new", type: :view do
  before(:each) do
    assign(:load, Load.new(
      :weight => "9.99",
      :state => "MyString",
      :user => nil,
      :machine => nil
    ))
  end

  it "renders new load form" do
    render

    assert_select "form[action=?][method=?]", loads_path, "post" do

      assert_select "input#load_weight[name=?]", "load[weight]"

      assert_select "input#load_state[name=?]", "load[state]"

      assert_select "input#load_user_id[name=?]", "load[user_id]"

      assert_select "input#load_machine_id[name=?]", "load[machine_id]"
    end
  end
end
