require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user)          { FactoryBot.create(:user) }
  let(:Authorization) { auth_token(user) }
  let(:project)       { FactoryBot.create(:project, user_id: user.id) }

  context 'when valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:task, project_id: project.id)).to(be_valid)
    end
  end
end
