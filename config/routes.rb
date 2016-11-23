Rails.application.routes.draw do
  mount Welcome::API => "/"
  mount Client::API => "/"
  mount Oauth::API => "/"
end
