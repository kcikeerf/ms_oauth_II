module SwtkOauth
  module Document
    module Base

      #def self.included(base)
        #base.extend(ClassMethods)
      #end

      def base_uri(request)
        http_method = request.request_method
        protocol = request.headers["Version"]
        host = request.host_with_port
        name = self.class.name.underscore.pluralize
        id   = self.id.to_s
        uri  = http_method + "/" + protocol + "/" + host + "/" + name + "/" +  id
      end
      # def access_uri(client_id, machine_code, req)
      #   result = ""
      #   http_method = req.request_method
      #   protocol = req.headers["Version"]
      #   host = req.host_with_port
      #   name = self.class.name.underscore.pluralize
      #   id   = self.id.to_s
      #   result  = client_id + "/" + machine_code + "/" + http_method + "/" + protocol + "/" + host + "/" + name + "/" +  id
      #   return result
      # end
    end
  end
end