require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'

RSpec.describe Dryer, type: :model do
  let(:user) { create(:user) }
  let(:dryer) { create(:dryer) }
  let(:load) { create(:load, weight: 10 , user: user) }
  it_behaves_like 'a general machine' do

    let(:machine) { dryer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { dryer }
    let(:load) { create(:load, weight: 10 , user: user) }
    let(:bigLoad) { create(:load, weight: 16, user: user) }
    let(:sufficient_coins) { 1 }
    let(:insufficient_coins) { 0 }

  end


end
# end
