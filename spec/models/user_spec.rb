require 'rails_helper'

RSpec.describe User, type: :model do
  context 'respond_to' do
    it { is_expected.to respond_to(:email) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }

    it 'valid user' do
      user = User.create!(email: 'test@test.com', password_digest: 'password')
      
      expect(user.valid?).to be_truthy
    end

    it 'invalid user' do
      User.create!(email: 'test@test.com', password_digest: 'password')
      user = User.new(email: 'test@test.com', password_digest: 'password2')

      expect(user.valid?).to be_falsey
    end
  end
end
