class Product < ApplicationRecord
  # Указываю, что продукт принадлежит корзине
  belongs_to :cart
  # указываю, что нужно проверять название на наличие,
  # количесетво и цену на наличие и на больше нуля
  validates :name, presence: true
  validates :quantity, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
end
