require 'rails_helper'

RSpec.describe "washers/index", type: :view do
  before(:each) do
    assign(:washers, [
      Washer.create!(
        :name => "Name",
        :position => 1,
        :type => "Type",
        :state => "State",
        :user => nil
      ),
      Washer.create!(
        :name => "Name",
        :position => 1,
        :type => "Type",
        :state => "State",
        :user => nil
      )
    ])
  end

  it "renders a list of washers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
