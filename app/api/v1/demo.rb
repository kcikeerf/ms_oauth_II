module Demo
	class API < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api

		helpers do
	
		end

		resource :server do
			desc 'server info'
		 	get :info do
				{data:`uname -a`}
			end

			desc 'others info'
			params do
			  optional :beer
			  optional :wine
			  optional :juice
			  at_least_one_of :beer, :wine, :juice, message: "all params are required or none is required"
			end
			get :others do
				{data: "others"}
			end
		end
	end
end