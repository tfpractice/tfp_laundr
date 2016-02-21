require 'rails_helper'

RSpec.describe SWasher, type: :model do
  let(:user) { create(:user) }
  let(:s_washer) { build_stubbed(:s_washer, user: user) }

  it 'has a name' do
    expect(s_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(s_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(s_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "s_washer"' do
    puts s_washer.inspect
    expect(s_washer.type).to be_a_kind_of(String)

  end
end
