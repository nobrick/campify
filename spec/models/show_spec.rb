require 'rails_helper'

RSpec.describe Show, type: :model do
  it 'creates show model' do
    expect(create :show).to be_persisted
  end
end
