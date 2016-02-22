require 'rails_helper'

RSpec.describe "dryers/edit", type: :view do
  before(:each) do
    @dryer = assign(:dryer, Dryer.create!(
      :name => "MyString",
      :position => 1,
      :state => "MyString",
      :user => nil
    ))
  end

  it "renders the edit dryer form" do
    render

    assert_select "form[action=?][method=?]", dryer_path(@dryer), "post" do

      assert_select "input#dryer_name[name=?]", "dryer[name]"

      assert_select "input#dryer_position[name=?]", "dryer[position]"

      assert_select "input#dryer_state[name=?]", "dryer[state]"

      assert_select "input#dryer_user_id[name=?]", "dryer[user_id]"
    end
  end
end
