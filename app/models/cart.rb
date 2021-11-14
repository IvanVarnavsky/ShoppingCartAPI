class Cart < ApplicationRecord
    # Говорю, что корзина покупок имеет много продуктов и при удалении корзины удалять и все ее продукты
    has_many :products, dependent: :destroy
    # Указываю, что перед записью нужно проверять token на наличие и уникальность
    validates :token, presence: true, uniqueness: true
end
