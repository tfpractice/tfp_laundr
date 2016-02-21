require 'rails_helper'

RSpec.describe "washers/show", type: :view do
  before(:each) do
    @washer = assign(:washer, Washer.create!(
      :name => "Name",
      :position => 1,
      :type => "Type",
      :state => "State",
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(//)
  end
end
