require 'rails_helper'

RSpec.describe XlWasher, type: :model do
  let(:user) { create(:user) }
  let(:xl_washer) { build_stubbed(:xl_washer, user: user) }

  it 'has a name' do
    expect(xl_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(xl_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(xl_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "xl_washer"' do
    # puts xl_washer.inspect
    expect(xl_washer.type).to be_a_kind_of(String)

  end

end
