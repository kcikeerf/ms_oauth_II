module ApiHelper
  # 查询client
  def find_client(params)
    if !params[:client_id].blank? && !params[:secret].blank? && !params[:machine_code].blank?
      target_client = Oauth::Client.where(id: params[:client_id], secret: params[:secret], machine_code: params[:machine_code]).first
    else
      target_client = nil
    end

    if target_client
      return target_client
    else
      error!(message_json("error","e40000"), 401)
    end
  end

  def message_json type, code
    {
      code: code,
      message: I18n.t("#{type}.#{code}")
    }
  end
end