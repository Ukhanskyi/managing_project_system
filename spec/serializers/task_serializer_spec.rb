require 'rails_helper'

RSpec.describe TaskSerializer do
  let(:task)       { FactoryBot.create(:task) } # Time when was writen spec
  let(:serializer) { described_class.new(task) }

  it 'includes the correct attributes' do
    expect(serializer.serializable_hash[:data][:attributes].keys).to contain_exactly(:id, :name, :description, :status, :project_id, :created_at, :updated_at)
  end
end
