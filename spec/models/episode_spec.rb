require 'rails_helper'

RSpec.describe Episode, type: :model do
  it 'requires a title and artist' do
    artist = Artist.create!(name: 'DJ Test')
    ep = described_class.new(title: 'Ep 1', artist: artist)
    expect(ep).to be_valid

    no_title = described_class.new(artist: artist)
    expect(no_title).not_to be_valid
    expect(no_title.errors[:title]).to be_present
  end
end

