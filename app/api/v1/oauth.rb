module Oauth
	class API < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api

		helpers do
	
		end

		resource :oauth do
			desc 'get authorize code'
		 	get :get_access_token do
				{data:`uname -a`}
			end

			desc 'others info'
			# params do
			#   optional :beer
			#   optional :wine
			#   optional :juice
			#   all_or_none_of :beer, :wine, :juice, message: "all params are required or none is required"
			# end
			get :others do
				{data: "others"}
			end
		end
	end
end
