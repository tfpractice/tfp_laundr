require 'rails_helper'

RSpec.describe "washers/edit", type: :view do
  before(:each) do
    @washer = assign(:washer, Washer.create!(
      :name => "MyString",
      :position => 1,
      :type => "",
      :state => "MyString",
      :user => nil
    ))
  end

  it "renders the edit washer form" do
    render

    assert_select "form[action=?][method=?]", washer_path(@washer), "post" do

      assert_select "input#washer_name[name=?]", "washer[name]"

      assert_select "input#washer_position[name=?]", "washer[position]"

      assert_select "input#washer_type[name=?]", "washer[type]"

      assert_select "input#washer_state[name=?]", "washer[state]"

      assert_select "input#washer_user_id[name=?]", "washer[user_id]"
    end
  end
end
