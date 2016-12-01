# -*- coding: UTF-8 -*-

class Oauth::OauthPageToken
  include Mongoid::Document
  include Mongoid::Timestamps
  # include SwtkOauth::Document::Base

  # belongs_to :client, class_name: "Oauth::Client"
  
  field :client_id, type: String
  # field :machine_code, type: String
  # field :access_uri, type: String
  field :redirect_uri, type: String   #无转向链接，暂作保留
  field :scope, type: String #限定访问范围
  field :scope_values, type: Array, default: []    # scope parsed as array of allowed actions
  field :token, type: String                               # access token
  field :token_expired_at, type: Time, default: nil  # token expiration
  field :refresh_token, type: String                          # refresh token
  field :refresh_token_expired_at, type: Time, default: nil
  # field :granted_times, type: Integer, default: 0  # tokens granted in the authorization step
  # field :revoked_times, type: Integer, default: 0  # tokens revoked in the authorization step
  field :blocked, type: Time, default: nil    # access token block (if client is blocked)

  index({_id:1}, {background: true})
  # index({redirect_uri:1}, {unique: true, background: true})
  # index({client_id:1, machine_code:1}, {unique: true, background: true})
  index({token:1}, {unique: true, background: true})
  index({refresh_token:1}, {unique: true, background: true})
  index({token:1, refresh_token:1}, {unique: true, background: true})

  # validates :client_id, presence: true
  # validates :machine_code, presence: true

  # scope :by_redirect_uri, -> (uri) { where(redirect_uri: uri) }

  before_create :random_token
  before_create :create_token_expiration
  before_create :random_refresh_token
  before_create :create_refresh_token_expiration
  before_create :construct_scope_values

  # validates :client_uri, presence: true, format: { with: URI::regexp(%w(http https)), message: "invalid url" }
  # validates :resource_owner_uri, presence: true, format: { with: URI::regexp(%w(http https)), message: "invalid url" }

  class << self
    def refresh_oauth_token token, refresh_token
      target_oauth_token = self.where(token: token, refresh_token: refresh_token).first
      if target_oauth_token
        # 更新token
        target_oauth_token.refresh_token!
      end
      return target_oauth_token
    end
  end

  def access_token_resp_json
    access_token_expired_in = self.token_expired_at.strftime("%s").to_i - Time.now.strftime("%s").to_i
    refresh_token_expired_in = self.refresh_token_expired_at.strftime("%s").to_i - Time.now.strftime("%s").to_i
    if access_token_expired_in > 0
      if refresh_token_expired_in > 0
        {
          token_type: "bearer",
          access_token: self.token,
          expired_in: access_token_expired_in,
          refresh_token: self.refresh_token
        }
      else
        Common::message_json("error", "e41000")
      end
    else
      if refresh_token_expired_in > 0
        Common::message_json("error", "e41100")
      else
        Common::message_json("error", "e41000")
      end
    end
  end

  # Check if the status is or is not blocked
  def blocked?
    !self.blocked.nil?
  end
  
  # Block the resource owner delegation to a specific client
  def block!
    self.blocked = Time.now
    self.save
  end

  def token_expired?
    self.token_expired_at < Time.now
  end

  def refresh_token_expired?
    self.refresh_token_expired_at < Time.now
  end

  def refreshable?
    !blocked? && token_expired? && !refresh_token_expired?
  end

  def refresh_token!
    self.random_token
    self.create_token_expiration
    self.save!
  end

  def refresh_fresh_token!
    self.random_refresh_token
    self.create_refresh_token_expiration
    self.save!
  end

  def token_available?
    !self.blocked? && !self.token_expired? && !self.refresh_token_expired?
  end

  #private

  def random_token
    self.token = SecureRandom.hex(SwtkOauthConfig.settings["random_length"])
  end

  def random_refresh_token
    self.refresh_token = SecureRandom.hex(SwtkOauthConfig.settings["random_length"])
  end

  def create_token_expiration
    self.token_expired_at = Chronic.parse("in #{SwtkOauthConfig.settings["token_expires_in"]} seconds")
  end

  def create_refresh_token_expiration
    self.refresh_token_expired_at = Chronic.parse("in #{SwtkOauthConfig.settings["fresh_token_expires_in"]} seconds")
  end

  def construct_scope_values
    self.scope_values = self.scope.split(SwtkOauthConfig.settings["scope_separator"]) if self.scope.is_a? Array
  end

  # def create_redirect_uri
  # 	self.redirect_uri = Common::construct_redirect_uri
  # end
end
