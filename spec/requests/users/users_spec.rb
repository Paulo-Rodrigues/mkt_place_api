require 'rails_helper'

describe 'Users' do
  context '#index' do
    it 'success' do
      users = create_list(:user, 2)

      get '/api/v1/users'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(users[0].email)
      expect(response.body).to include(users[1].email)
    end
  end

  context '#show' do
    it 'show user' do
      user = create(:user)

      get "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(200)
      expect(response.body).to include(user.email)
    end
  end

  context '#create' do
    it 'success' do
      user_params = { user: { email: 'test@test.com', password: '123456' } }
      post '/api/v1/users', params: user_params

      expect(User.count).to eq(1)
      expect(response).to have_http_status(201)
    end

    it 'failure' do
      another_user = create(:user)
      user_params = { user: { email: another_user.email, password: '123456' } }
      post '/api/v1/users', params: user_params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context '#update' do
    it 'success' do
      user = create(:user)
      params = { user: { email: 'other@email.com' } }
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
      patch "/api/v1/users/#{user.id}", params: params, headers: headers

      expect(response).to have_http_status(:success)
      expect(response.body).to include('other@email.com')
    end

    it 'forbidden' do
      user = create(:user)
      params = { user: { email: 'other@email.com' } }
      patch "/api/v1/users/#{user.id}", params: params

      expect(response).to have_http_status(:forbidden)
    end

    it 'failure' do
      user = create(:user)
      params = { user: { email: '' } }
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
      patch "/api/v1/users/#{user.id}", params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context '#destroy' do
    it 'success' do
      user = create(:user)
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
      delete "/api/v1/users/#{user.id}", headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'forbidden' do
      user = create(:user)
      delete "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:forbidden)
    end
  end
end
