class Category < ActiveRecord::Base
  has_many :categories_products
  has_many :products, through: :categories_products
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true

  def top_four
    products = self.products.sort_by{|pro| pro.avg_rating}
    return products[0..3]
  end

end
