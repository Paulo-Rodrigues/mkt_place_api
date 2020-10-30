class Product < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements

  validates :title, :price, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :filter_by_title, ->(term) { where('lower(title) LIKE ?', "%#{term.downcase}%") }

  scope :above_or_equal_to_price, ->(price) { where('price >= ?', price) }

  scope :bellow_or_equal_to_price, ->(price) { where('price <= ?', price) }

  scope :recent, -> { order(created_at: :desc) }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.where(id: params[:product_ids]) : Product.all
    products = products.filter_by_title(params[:term]) if params[:term]
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
    products = products.bellow_or_equal_to_price(params[:max_price]) if params[:max_price]
    products = products.recent if params[:recent]
    products
  end
end
