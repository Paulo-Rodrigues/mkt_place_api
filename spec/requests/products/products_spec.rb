require 'rails_helper'

describe 'Products' do
  context '#index' do
    it 'success' do
      products = create_list(:product, 2)

      get '/api/v1/products'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(products[0].title)
      expect(response.body).to include(products[1].title)
    end
  end

  context '#show' do
    it 'success' do
      product = create(:product)

      get "/api/v1/products/#{product.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include(product.title)
    end
  end

  context '#create' do
    it 'success' do
      user = create(:user)
      params = { product: { title: 'P1', price: '15.5', published: true } }
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
      post '/api/v1/products', params: params, headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'failure' do
      user = create(:user)
      params = { product: { title: '', price: '', published: true } }
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }
      post '/api/v1/products', params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'forbidden' do
      params = { product: { title: '', price: '', published: true } }
      post '/api/v1/products', params: params

      expect(response).to have_http_status(:forbidden)
    end
  end

  context '#update' do
    it 'success' do
      product = create(:product)
      params = { product: { title: 'Updated Title' } }
      headers = { Authorization: JsonWebToken.encode(user_id: product.user.id) }

      patch "/api/v1/products/#{product.id}", params: params, headers: headers

      expect(response).to have_http_status(:success)
    end

    it 'failure' do
      product = create(:product)
      params = { product: { title: '' } }
      headers = { Authorization: JsonWebToken.encode(user_id: product.user.id) }

      patch "/api/v1/products/#{product.id}", params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'forbidden' do
      product = create(:product)
      params = { product: { title: 'title' } }

      patch "/api/v1/products/#{product.id}", params: params

      expect(response).to have_http_status(:forbidden)
    end
  end

  context '#destroy' do
    it 'success' do
      product = create(:product)
      headers = { Authorization: JsonWebToken.encode(user_id: product.user.id) }

      delete "/api/v1/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'forbidden' do
      product = create(:product)
      user = create(:user)
      headers = { Authorization: JsonWebToken.encode(user_id: user.id) }

      delete "/api/v1/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
