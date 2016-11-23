module SwtkOauth
  module Document
    module Base

      #def self.included(base)
        #base.extend(ClassMethods)
      #end

      def base_uri(request)
        p request.host_with_port
        protocol = request.headers["Version"]
        host = request.host_with_port
        name = self.class.name.underscore.pluralize
        id   = self.id.to_s
        p protocol
        p host
        p name
        p id
        uri  = protocol + host + "/" + name + "/" +  id
      end

    end
  end
end