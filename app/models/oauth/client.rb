class Oauth::Client
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  # field :client_id, type: Boolean
  field :service_type, default: "swtk" # reports, papers
  field :secret #登录客户端时指定 secret字符串
  field :swtk_scope, type: Integer, default: 0 # 0: 租户内部用， 1: 跨租户
  field :published, type: Boolean, default: false #是否公开 
  field :tenant_uid, type: String, default: "0" # 租户
  field :machine_code, type: String# 未来动态生成
  field :created_by, type: String
  field :scope, type: Array, default: []           # raw scope with keywords
  field :scope_values, type: Array, default: []    # scope parsed as array of allowed actions
  field :info, type: String
  field :blocked, type: Time, default: nil         # blocks any request from the client

  index({_id:1}, {background: true})
  index({name:1, host_uid:1}, {unique: true, background: true})

  validates :name, presence: true, uniqueness: true
  validates :service_type, presence: true
  validates :secret, presence: true
  validates :machine_code, presence: true

  before_create  :random_host_uid
  before_destroy :clean
  # after_create   :construct_client_id

  # validates :uri, presence: true, format: { with: URI::regexp(%w(http https)), message: "invalid url" }
  # validates :created_from, presence: true, format: { with: URI::regexp(%w(http https)), message: "invalid url" }
  # validates :redirect_uri, presence: true, format: { with: URI::regexp(%w(http https)), message: "invalid url" }


  # Block the client
  def block!
    self.blocked = Time.now
    self.save
    OauthToken.block_client!(self.uri)
    OauthAuthorization.block_client!(self.uri)
  end

  # Unblock the client
  def unblock!
    self.blocked = nil
    self.save
  end

  # Check if the status is or is not blocked
  def blocked?
    !self.blocked.nil?
  end

  # Increase the counter of resource owners granting the access
  # to the client
  def granted!
    self.granted_times += 1
    self.save
  end

  # Increase the counter of resource owners revoking the access
  # to the client
  def revoked!
    self.revoked_times += 1
    self.save
  end
  
  def scope_pretty
    separator = SwtkOauthConfig.settings["scope_separator"]
    scope.join(separator)
  end

  def scope_values_pretty
    separator = SwtkOauthConfig.settings["scope_separator"]
    scope_values.join(separator)
  end

  class << self

    # Filter to the client uri (internal identifier) and the
    # redirect uri
    def where_uri(client_uri, redirect_uri)
      where(uri: client_uri, redirect_uri: redirect_uri)
    end

    # Filter to the client secret and the redirect uri
    def where_secret(secret, client_uri)
      where(secret: secret, uri: client_uri)
    end

    # Filter to the client scope
    def where_scope(scope)
      all_in(scope_values: scope)
    end

    # Sync all clients with the correct exploded scope when a
    # scope is modified (changed or removed)
    def sync_clients_with_scope(scope)
      Oauth::Client.all.each do |client|
        scope_string = client.scope.join(SwtkOauthConfig.settings["scope_separator"])
        client.scope_values = SwtkOauthConfig.normalize_scope(scope_string)
        client.save
      end
    end
  end


  private

    def clean
      # 删除oauth_token, oauth_authorization中的相关所有记录
      # to be implemented
      #
    end

    # def construct_client_id
    #   self.client_id = self.service_type + self.id.to_s
    # end

    def random_host_uid
      self.machine_code=Time.now.to_snowflake.to_s
    end
end
