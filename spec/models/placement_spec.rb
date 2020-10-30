require 'rails_helper'

RSpec.describe Placement, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product).inverse_of(:placements) }
  end
end
