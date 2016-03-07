require 'rails_helper'
require 'shared/machine'

RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:washer, type: "MWasher") }
  # let(:washer) { create(:m_washer) }
  let(:load) { create(:load, user: user, weight: 5) }
  it_behaves_like 'a general machine' do

    let(:machine) { washer }

  end
end
# end
