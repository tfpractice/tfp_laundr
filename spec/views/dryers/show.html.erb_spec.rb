require 'rails_helper'

RSpec.describe "dryers/show", type: :view do
  before(:each) do
    @dryer = assign(:dryer, Dryer.create!(
      :name => "Name",
      :position => 1,
      :state => "State",
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(//)
  end
end
