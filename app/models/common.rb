module Common
  # 组装当前访问uri
  def access_uri(client_id, machine_code, req)
    result = ""
    http_method = req.request_method
    protocol = req.headers["Version"]
    host = req.host_with_port
    name = self.class.name.underscore.pluralize
    id   = self.id.to_s
    result  = client_id + "/" + machine_code + "/" + http_method + "/" + protocol + "/" + host + "/" + name + "/" +  id
    return result
  end
end