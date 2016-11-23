module Welcome
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do

    end

    resource :welcome do
      desc 'welcome message'
      get :message do
        {message: "Welcome!"}
      end
    end
  end
end