require 'rails_helper'

RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { build_stubbed(:washer, user: user) }

  it 'has a name' do
  	expect(washer.name).to be_a_kind_of(String)
  end
   it 'has a position' do
  	expect(washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
  	  	expect(washer.user).to be_a_kind_of(User)

  end


end
