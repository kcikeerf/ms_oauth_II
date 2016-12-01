module Common
  module_function

  def message_json type, code
    {
      errcode: code,
      errmsg: I18n.t("#{type}.#{code}")
    }
  end

  def construct_redirect_uri req
  	arr = []
    arr << req.request_method
    arr << req.url
    # protocol = req.headers["Version"]
    # host = req.host_with_port
    # fullpath = req.fullpath
    #name = self.class.name.underscore.pluralize
    # id   = self.id.to_s
    uri  = arr.join("/")
    return uri
  end
end