require 'rails_helper'

RSpec.describe University, type: :model do
  let(:university) { create :university }
  it 'creates university model' do
    expect(university).to be_persisted
  end

  it 'destroys self and its associated votes' do
    vote = create :campus_vote, university_id: university.id
    university.destroy
    expect { vote.reload }.to raise_error ActiveRecord::RecordNotFound
  end
end
