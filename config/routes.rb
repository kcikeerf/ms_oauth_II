Rails.application.routes.draw do
  mount Demo::API => "/"
  mount Client::API => "/"
  mount Oauth::API => "/"
end
