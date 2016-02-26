require 'rails_helper'

RSpec.describe "loads/show", type: :view do
  before(:each) do
    @load = assign(:load, Load.create!(
      :weight => "9.99",
      :state => "State",
      :user => nil,
      :machine => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
