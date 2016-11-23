module Client
	class API < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api

		helpers do
		end

		resource :client do
			desc 'get client list'
			params do
			  requires :admin_token, type: String, values: -> {["k12ke_admin"]}
			end
		 	post :list do
		 		Oauth::Client.all
			end

			desc 'create'
			params do
        requires :admin_token, type: String, values: -> {["k12ke_admin"]}
  			requires :name, type: String, allow_blank: false
  			requires :secret, type: String, allow_blank: false
  			optional :site_uri, type: String, default: ""
  			optional :redirect_uri, type: String, default: ""
  			optional :scope, type: Array, default: []  
  			optional :scope_values, type: Array, default: []  
    	end
			post :create do
        params.extract!(:admin_token)
				a_client = Oauth::Client.new(params)
        a_client.uri = a_client.base_uri(request)
        if a_client.save
          {message: "Client(#{params[:name]}) created successfully!"}
        else
          {message: "Client(#{params[:name]}) created failed!"}
        end
			end

      desc 'destroy'
      params do
        requires :admin_token, type: String, values: -> {["k12ke_admin"]}
        requires :id, type: String, allow_blank: false
      end
      post :destroy do
        target_client = Oauth::Client.where(id: params[:id]).first
        if target_client && target_client.destroy
          {message: "Client(#{target_client.name}) deleted successfully!"}
        else
          {message: "Client(#{params[:id]}) deleted failed!"}
        end
      end
		end
	end
end
