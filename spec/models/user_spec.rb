require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build_stubbed(:user) }
  describe 'attributes' do
    it 'has an email address' do
      expect(user.email).to be_a_kind_of(String)
    end
    it 'has an username' do
      expect(user.username).to be_a_kind_of(String)
    end
    it 'has an password' do
      expect(user.password).to be_a_kind_of(String)
    end
    describe 'admin' do
      it 'has an admin' do
        expect(user.attributes).to include("admin")
      end
      it 'defaults admin to false' do
        expect(user.admin).to be false
      end
    end
  end

end
