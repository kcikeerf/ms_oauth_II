# -*- coding: UTF-8 -*-

module Client
	class API < Grape::API
		version 'v1', using: :path #/api/v1/<resource>/<action>
		format :json
		prefix :api

		helpers ApiHelper
    helpers SharedParamsHelper

#######################
# 未来只开放给后台
		resource :client do
      # 不需要获得client
      group do
        # 获取登录客户端列表
        desc 'get client list'
        params do
          use :admin
        end
        post :list do
          Oauth::Client.all
        end

        # 注册客户端
        desc 'create'
        params do
          requires :name, type: String, allow_blank: false
          requires :secret, type: String, allow_blank: false
          optional :machine_code, type: String, allow_blank: false
          optional :swtk_scope, type: String
          optional :published, type: Boolean
          optional :tenant_uid, type: String
          optional :scope, type: Array, default: []  
          optional :scope_values, type: Array, default: []
          optional :info, type: String, default: []
          use :admin
        end
        post :create do
          params.extract!(:admin_token)
          #unless Oauth::Client.where().first
            params[:created_by] = params[:admin_token]
            a_client = Oauth::Client.new(params)
            # a_client.uri = a_client.base_uri(request)
            if a_client.save
              {message: "Client(#{params[:name]}) created successfully!"}
            else
              status 500
              {message: "Client(#{params[:name]}) created failed! (error: #{a_client.errors})"}
            end
          #else
          #  status 500
          #  {message: "Client(#{params[:name]}) already existed!"}
          #end
        end
      end

      # 需要事先获得client
      group do
        before do
          @client = find_client(params)
        end

        # 删除客户端
        desc 'destroy'
        params do
          requires :id, type: String, allow_blank: false
          use :admin
        end
        post :destroy do
          target_client = @client
          if target_client && target_client.destroy
            {message: "Client(#{target_client.name}) deleted successfully!"}
          else
            status 500
            {message: "Client(#{params[:id]}) deleted failed!"}
          end
        end

        # 验证客户端
        desc 'verify'
        params do
          use :admin, :client
        end
        post :verify do
          {
            name: @client.name,
            client_id: @client.id.to_s
          }
        end

        # 公开客户端
        desc 'publish client'
        params do
          use :admin, :client
        end
        post :publish do
          current_client = @client
          unless current_client.published
            current_client.update({:published => true})
            {message: "Client(#{params[:id]}) published!"}
          else
            {message: "Client(#{params[:id]}) is published!"}
          end
        end
      end
#########################
		end
	end
end
