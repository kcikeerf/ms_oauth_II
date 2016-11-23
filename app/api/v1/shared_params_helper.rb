module SharedParamsHelper
  extend Grape::API::Helpers
  
  params :admin do
    requires :admin_token, type: String, values: -> {["k12ke_admin"]}
  end

  params :client do
    requires :client_id, type: String
    requires :secret, type: String
    requires :machine_code, type: String
  end
end