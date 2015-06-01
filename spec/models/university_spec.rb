require 'rails_helper'

RSpec.describe University, type: :model do
  it 'creates university model' do
    expect(create :university).to be_persisted
  end
end
