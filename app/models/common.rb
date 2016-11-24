module Common
  module_function

  def error_message_json code
    {
      errcode: code,
      errmsg: I18n.t("error.#{code}")
    }
  end
end