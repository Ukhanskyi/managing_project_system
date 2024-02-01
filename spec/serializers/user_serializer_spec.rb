require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { FactoryBot.create(:user, created_at: '2024-01-31T23:01:45.328Z') } # Time when was writen spec
  let(:serializer) { described_class.new(user) }

  it 'includes the correct attributes' do
    expect(serializer.serializable_hash[:data][:attributes].keys).to contain_exactly(:id, :email, :created_at, :created_date)
  end

  it 'formats created_date attribute correctly' do
    expect(serializer.serializable_hash[:data][:attributes][:created_date]).to eq('01/31/2024')
  end
end
