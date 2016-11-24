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
        requires :grant_type, type: String, values: -> {["clientcredentials"]}
        optional :scope, type: String
        use :client
      end
      post :get_access_token do
        if true #@client.published
          target_token = Oauth::OauthToken.get_oauth_token(@client, params)
          target_token.access_token_resp_json
        else
          # to be implemented
        end
      end

      # 验证 access token
      desc 'refresh access token'
      params do
        requires :grant_type, type: String, values: -> {["refresh_token"]}
        requires :refresh_token, type: String, allow_blank: false
        use :client
      end
      post :refresh_access_token do
        target_token.where()
      end

      # 验证 access token
      desc 'verify access token'
      params do
        requires :access_token, type: String, allow_blank: false
        use :client
      end
      post :verify_access_token do

      end

      # 验证 access token
      desc 'destroy access token'
      params do
        requires :access_token, type: String, allow_blank: false
        use :client
      end
      post :destroy_access_token do

      end

    end
  end
end
