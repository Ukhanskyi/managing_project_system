require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'when valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:project)).to(be_valid)
    end
  end
end
