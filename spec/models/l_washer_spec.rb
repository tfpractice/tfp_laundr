require 'rails_helper'

RSpec.describe LWasher, type: :model do
  let(:user) { create(:user) }
  let(:l_washer) { build_stubbed(:l_washer, user: user) }

  it 'has a name' do
    expect(l_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(l_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(l_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "l_washer"' do
    puts l_washer.inspect
    expect(l_washer.type).to be_a_kind_of(String)

  end
end
