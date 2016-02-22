require 'rails_helper'

RSpec.describe "dryers/index", type: :view do
  before(:each) do
    assign(:dryers, [
      Dryer.create!(
        :name => "Name",
        :position => 1,
        :state => "State",
        :user => nil
      ),
      Dryer.create!(
        :name => "Name",
        :position => 1,
        :state => "State",
        :user => nil
      )
    ])
  end

  it "renders a list of dryers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
