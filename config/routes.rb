Rails.application.routes.draw do
  mount Welcome::API => "/"
  mount Client::API => "/"
  mount OauthClient::API => "/"
  mount Authorize::API => "/"
  mount Token::API => "/"
end
