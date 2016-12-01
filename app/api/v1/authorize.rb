# -*- coding: UTF-8 -*-

module Authorize
  class API < Grape::API
    version 'v1', using: :path #/api/v1/<resource>/<action>
    format :json
    prefix :api

    helpers ApiHelper
    helpers SharedParamsHelper

    resource :authorize do
      group do # group begin
        before do
          @client = find_client(params)
        end

        #
        # Authorization
        # 1. code: 授权码
        # 2. token: 简化模式
        #
        desc 'new authorize'
        params do
          requires :response_type, type: String, values: -> {["code","token"]}
          requires :redirect_uri, type: String
          optional :scope, type: String
          optional :state, type: String
          use :client_basic
        end
        post :create do
          # 授权码
          if params[:response_type] == "code"
            target = Oauth::OauthAuthorization.new({
              :client_id => params[:client_id],
              :redirect_uri => params[:redirect_uri],
              :scope => params[:scope]
            })
            if target.save!
              {
                code: target.code,
                state: params[:state]
              }
            else
              status 500
              {message: "Authorization created failed!"}
            end
          elsif params[:response_type] == "token"         
            # to be implemented
          else
            #do nothing
          end
        end
      end # group end

    end
  end
end