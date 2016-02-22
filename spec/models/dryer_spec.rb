require 'rails_helper'

RSpec.describe Dryer, type: :model do
  let(:dryer) { create(:dryer) }

  it 'has a name' do
    expect(dryer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(dryer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(dryer).to respond_to(:user)
    # expect(dryer.user).to be_a_kind_of(User)

  end
end
