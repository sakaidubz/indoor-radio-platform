require 'rails_helper'

RSpec.describe Artist, type: :model do
  it 'is invalid without a name' do
    artist = described_class.new
    expect(artist).not_to be_valid
    expect(artist.errors[:name]).to be_present
  end
end

