require 'rails_helper'

class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

describe Authenticable do
  let(:authentication) { MockController.new }

  it 'get user from Authorization token' do
    user = create(:user)
    authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)

    expect(user.id).to eq(authentication.current_user.id)
  end
end
