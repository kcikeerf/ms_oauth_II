module Oauth
  class API < Grape::API
    version 'v1', using: :path #/api/v1/<resource>/<action>
    format :json
    prefix :api

    helpers ApiHelper
    helpers SharedParamsHelper

    resource :oauth do
      before do
        @client = find_client(params)
      end

      # 简化模式
      # 返回 access token
      desc 'get access token'
      params do
        requires :response_type, type: String, values: -> {["token"]}
        requires :access_uri, type: String
        optional :scope, type: String
        optional :state, type: String
        use :admin, :client
      end
      get :get_access_token do
        if @client.published
          Oauth::OauthToken.get_access_token request
        else
          status 403
          {message: "Invalid Client!"}
        end
      end

      # 验证 access token
      desc 'verify access token'
      params do
        requires :access_token, type: String, allow_blank: false
        #requires :
      end
      post :verify_access_token do

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
