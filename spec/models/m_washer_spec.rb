require 'rails_helper'

RSpec.describe MWasher, type: :model do
let(:user) { create(:user) }
  let(:m_washer) { build_stubbed(:m_washer, user: user) }

  it 'has a name' do
    expect(m_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(m_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(m_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "m_washer"' do
    puts m_washer.inspect
    expect(m_washer.type).to be_a_kind_of(String)

  end
end
