Rails.application.routes.draw do
  mount SwtkServer::API => "/"
end
