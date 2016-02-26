require 'rails_helper'

RSpec.describe "loads/index", type: :view do
  before(:each) do
    assign(:loads, [
      Load.create!(
        :weight => "9.99",
        :state => "State",
        :user => nil,
        :machine => nil
      ),
      Load.create!(
        :weight => "9.99",
        :state => "State",
        :user => nil,
        :machine => nil
      )
    ])
  end

  it "renders a list of loads" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
