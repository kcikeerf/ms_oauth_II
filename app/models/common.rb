module Common
  module_function

  def message_json type, code
    {
      errcode: code,
      errmsg: I18n.t("#{type}.#{code}")
    }
  end
end