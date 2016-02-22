require 'rails_helper'

RSpec.describe "dryers/new", type: :view do
  before(:each) do
    assign(:dryer, Dryer.new(
      :name => "MyString",
      :position => 1,
      :state => "MyString",
      :user => nil
    ))
  end

  it "renders new dryer form" do
    render

    assert_select "form[action=?][method=?]", dryers_path, "post" do

      assert_select "input#dryer_name[name=?]", "dryer[name]"

      assert_select "input#dryer_position[name=?]", "dryer[position]"

      assert_select "input#dryer_state[name=?]", "dryer[state]"

      assert_select "input#dryer_user_id[name=?]", "dryer[user_id]"
    end
  end
end
