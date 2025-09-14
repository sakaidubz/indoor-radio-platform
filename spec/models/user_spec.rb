require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with username, email, password, and role' do
    user = described_class.new(username: 'tester', email: 't@example.com', password: 'secret123', role: 'editor')
    expect(user).to be_valid
  end

  it 'requires unique username and email' do
    described_class.create!(username: 'dup', email: 'dup@example.com', password: 'secret123', role: 'editor')
    user = described_class.new(username: 'dup', email: 'dup@example.com', password: 'secret123', role: 'editor')
    expect(user).not_to be_valid
    expect(user.errors[:username]).to be_present
    expect(user.errors[:email]).to be_present
  end

  it 'requires password authentication' do
    user = described_class.create!(username: 'authu', email: 'a@example.com', password: 'secret123', role: 'editor')
    expect(user.authenticate('secret123')).to be_truthy
    expect(user.authenticate('wrong')).to be_falsey
  end
end

