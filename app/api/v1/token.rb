# -*- coding: UTF-8 -*-

module Token
  class API < Grape::API
    version 'v1', using: :path #/api/v1/<resource>/<action>
    format :json
    prefix :api

    helpers ApiHelper

    resource :token do # oauth client begin
      group do # 需要验证授权码
        before do
          has_client?(params)
          @auth_code = find_authorize_code(params)
        end

        # 验证授权码并授予access token
        #
        desc 'create access token'
        params do
          requires :grant_type, type: String, values: -> {["authorized_code"]}
          requires :code, type: String
          requires :redirect_uri, type: String
          requires :client_id, type: String
        end
        post :create do
          if params[:grant_type] == "authorized_code"
            target = Oauth::OauthPageToken.new({
              :redirect_uri => params[:redirect_uri],
              :client_id => params[:client_id],
              :scope => @auth_code.scope
            })
            if target.save!
              target.access_token_resp_json
            else
              status 500
              {message: "Got access token failed!"}
            end
          else
            # do nothing
          end
        end
      end

      group do #

        # 验证access token
        #
        desc 'valid access token'
        params do
          requires :access_token, type: String
          requires :client_id, type: String
        end
        post :valid do
          target = Oauth::OauthPageToken.where({
            :token => params[:access_token],
            :client_id => params[:client_id]
          }).first
          if target && target.token_available?
            target.access_token_resp_json
          else
            status 401
            {message: "Access token valid!"}
          end
        end

        # 更新access token
        #
        desc 'refresh access token'
        params do
          requires :grant_type, type: String, values: -> {["refresh_token"]}
          requires :refresh_token, type: String
          requires :client_id, type: String
        end
        post :refresh do
          if params[:grant_type] == "refresh_token"
            target = Oauth::OauthPageToken.where({
              :refresh_token => params[:refresh_token],
              :client_id => params[:client_id]
            }).first
            if target && target.refreshable?
              target.refresh_token!
              target.access_token_resp_json
            else
              status 500
              {message: "Refresh access token failed!"}
            end
          else
            # do nothing
          end
        end
      end
    end # oauth client end
  end
end