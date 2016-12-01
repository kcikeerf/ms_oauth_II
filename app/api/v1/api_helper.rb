module ApiHelper
  # 查询client
  def find_client_strict(params)
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

  # 查询client
  def find_client(params)
    if !params[:client_id].blank? && !params[:secret].blank?
      target_client = Oauth::Client.where(id: params[:client_id], secret: params[:secret]).first
    else
      target_client = nil
    end

    if target_client
      return target_client
    else
      error!(message_json("error","e40000"), 401)
    end
  end

  # client是否存在
  def has_client?(params)
    target_client = Oauth::Client.where(id: params[:client_id]).first
    unless target_client
      error!(message_json("error","e40000"), 401)
    end
  end

  # 验证授权码
  def find_authorize_code(params)
    target = Oauth::OauthAuthorization.where(client_id: params[:client_id], code: params[:code]).first
    if target.blank? || target.expired?
      error!(message_json("error","e40100"), 401)
    else
      return target
    end
  end

  def message_json type, code
    {
      code: code,
      message: I18n.t("#{type}.#{code}")
    }
  end
end