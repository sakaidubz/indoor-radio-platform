require 'rails_helper'

RSpec.describe SocialPost, type: :model do
  it 'requires platform and content' do
    artist = Artist.create!(name: 'DJ Test')
    ep = Episode.create!(title: 'Ep 1', artist: artist)
    post = described_class.new(episode: ep, platform: 'x', content: 'Hello world')
    expect(post).to be_valid

    invalid = described_class.new(episode: ep)
    expect(invalid).not_to be_valid
    expect(invalid.errors[:platform]).to be_present
    expect(invalid.errors[:content]).to be_present
  end
end

