require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:price) }
  end

  context 'search' do
    it 'not find product' do
      search_terms = { term: 'monster truck', min_price: 100 }

      expect(Product.search(search_terms)).to be_empty
    end

    it 'find a tv' do
      create(:product, title: 'TV 42', price: 80)
      create(:product, title: 'TV 42', price: 180)
      search_terms = { title: 'TV 42', min_price: 50, max_price: 100 }

      expect(Product.search(search_terms).count).to eq(1)
    end

    it 'all products when no search terms' do
      expect(Product.all).to eq(Product.search({}))
    end
  end

  context 'filters' do
    it 'filter_by_title' do
      create(:product, title: 'TV 42')
      create(:product, title: 'TV 50')

      expect(Product.filter_by_title('tv').count).to eq(2)
    end

    context 'by price' do
      it 'above_or_equal_to_price' do
        create(:product, price: '100')
        create(:product, price: '200')
        create(:product, price: '300')

        expect(Product.above_or_equal_to_price(200).count).to eq(2)
      end

      it 'bellow_or_equal_to_price' do
        create(:product, price: '100')
        create(:product, price: '200')
        create(:product, price: '300')

        expect(Product.bellow_or_equal_to_price(200).count).to eq(2)
      end

      it 'most recent' do
        products = create_list(:product, 3)

        expect(Product.recent.first).to eq(products[2])
      end
    end
  end
end
