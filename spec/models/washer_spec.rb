require 'rails_helper'
require 'shared/machine'

RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:washer, type: "MWasher") }
  let(:load) { create(:load, user: user, weight: 5) }
  
  it_behaves_like 'a general machine' do
    let(:machine) { washer }
  end
  describe 'washer methods' do
  	# describe '#coin_excess?' do
  		# it 'checks if quantity coins inserted exceeds price ' do
  			# expect(washer).to respond_to(:coin_excess?)
  			# 
  		# end
  		# context 'when inserting insufficient coins' do
  			# it 'returns false' do
  				# washer.claim!(user)
  				# puts "slef.capacity #{washer.capacity}"
  				# washer.fill!(load)
  				# washer.insert_coins!(5)
  				# expect(washer.coin_excess?).to be(false)
  			# end
  			# 
  		# end
  	  # 
  	# end
    
  end
end
# end
