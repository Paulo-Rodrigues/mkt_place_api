require 'rails_helper'

describe 'User Token' do
  it 'should get jwt token' do
    user = create(:user)

    post '/api/v1/tokens', params: { user: { email: user.email, password: user.password } }

    expect(response).to have_http_status(:success)
    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:token]).not_to be_nil
  end

  it 'should not get jwt token' do
    user = create(:user)

    post '/api/v1/tokens', params: { user: { email: user.email, password: 'bad_pass' } }

    expect(response).to have_http_status(:unauthorized)
  end
end
