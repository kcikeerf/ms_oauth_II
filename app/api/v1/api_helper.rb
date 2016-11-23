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
      error!({message: 'Client Is Invalid'}, 403)
    end
  end
end