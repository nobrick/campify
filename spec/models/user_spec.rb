require 'rails_helper'

RSpec.describe User, :type => :model do
  let!(:user) { create :user, email: 'john@email.com', username: 'johndoe' }

  it 'creates a user' do
    expect(user).to be_a User
  end

  it 'raises when creating with case-insensitive same username' do
    expect { create :user, email: 'another@email.com', username: ' JohnDoe ' }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'raises when creating with case-insensitive same email' do
    expect { create :user, email: ' JOHN@email.com ', username: 'another' }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  describe 'username' do
    it 'is in length 3..18' do
      [ 3, 10, 18 ].each do |t|
        user = build(:user, username: 'a' * t)
        expect(user).to be_valid
      end

      [ 2, 19 ].each do |t|
        user = build(:user, username: 'a' * t)
        expect(user).not_to be_valid
      end
    end

    it 'allows only A-Z, a-z, 0-9 and _' do
      user = build(:user, username: 'john+doe')
      expect(user).not_to be_valid
    end

    it 'does not begin with _ or digit' do
      [ '_john_doe', '5john_doe' ].each do |u|
        user = build(:user, username: u)
        expect(user).not_to be_valid
      end
    end

    it 'does not contain __ inside' do
      [ 'john__doe', 'john___doe' ].each do |u|
        user = build(:user, username: u)
        expect(user).not_to be_valid
      end
    end

    it 'does not end with _' do
      user = build(:user, username: 'johndoe_')
      expect(user).not_to be_valid
    end
  end
end