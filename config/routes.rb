Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Добавление в корзину
  post '/cart/add', to: 'products#add'

  # Просмотр содержимого корзины
  get '/cart/show', to: 'carts#show'

  # Отображение товаров с суммой товаров в корзине
  get '/cart/summa', to: 'carts#summa'

  # Очистка корзины (удаление)
  delete '/cart/clear', to: 'carts#destroy'

  # Удаление (или уменьшение) какого-то кол-ва продукта в корзине либо полное его удаление
  delete '/cart/del', to: 'products#del'

  # Изменение количества продукта, на то которое придет в параметрах
  put '/cart/update', to: 'products#update'

  # Получение отдельно взятого продукта
  get '/cart/product', to: 'products#show'

  # Отображение отфильтрованного списка товаров
  get '/cart/filter', to: 'carts#filter'

  #resources :carts do
  #  resources :products
  #end
end
