require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user)          { FactoryBot.create(:user) }
  let(:Authorization) { auth_token(user) }

  context 'when valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:project, user_id: user.id)).to(be_valid)
    end
  end
end
