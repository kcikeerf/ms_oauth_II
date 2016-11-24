module Oauth
  class API < Grape::API
    version 'v1', using: :path #/api/v1/<resource>/<action>
    format :json
    prefix :api

    helpers ApiHelper
    helpers SharedParamsHelper

    resource :oauth do
      group do
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
            result = Oauth::OauthToken.get_oauth_token(@client, params)
            result.access_token_resp_json
          else
            # to be implemented
          end
        end

        # 验证 access token
        desc 'verify access token'
        params do
          requires :access_token, type: String, allow_blank: false
          use :client
        end
        post :verify_access_token do
          target_token = Oauth::OauthToken.where(token: params[:access_token]).first
          if target_token.token_available?
            message_json("info", "i11000")
          else
            status 401
            message_json("error", "e41000")
          end
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

      group do
        # 验证 access token
        desc 'refresh access token'
        params do
          requires :grant_type, type: String, values: -> {["refresh_token"]}
          requires :refresh_token, type: String, allow_blank: false
          #use :client
        end
        post :refresh_access_token do
          result = Oauth::OauthToken.refresh_oauth_token(params[:refresh_token])
          result.access_token_resp_json
        end
      end
    end
  end
end
