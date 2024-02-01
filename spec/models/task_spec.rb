require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'when valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:task)).to(be_valid)
    end
  end
end
