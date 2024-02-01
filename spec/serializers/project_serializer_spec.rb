require 'rails_helper'

RSpec.describe ProjectSerializer do
  let(:project) { FactoryBot.create(:project) }
  let(:serializer) { described_class.new(project) }

  it 'includes the correct attributes' do
    expect(serializer.serializable_hash[:data][:attributes].keys).to contain_exactly(:id, :name, :description, :user_id, :created_at, :updated_at)
  end
end
