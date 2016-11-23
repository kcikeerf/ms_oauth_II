module SwtkServer
	class API < Grape::API
		version 'v1', using: :header, vendor: "swtk"
		format :json
		prefix :api

		helpers do
	
		end

		resource :server do
			desc 'server info'
		 	get :info do
				{data:`uname -a`}
			end
		end
	end
end