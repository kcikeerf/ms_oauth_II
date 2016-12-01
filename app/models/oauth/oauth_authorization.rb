# -*- coding: UTF-8 -*-

class Oauth::OauthAuthorization
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :client, class_name: "Oauth::Client"

  # redirect_uri格式
  # <http method>_<url>
  field :client_id, type: String
  field :redirect_uri, type: String                           # client identifier
  field :code, type: String                                 # authorization code
  field :scope, type: Array, default: []         # scope accessible with request
  field :expire_at, type: Time                # authorization expiration (security reasons)
  field :blocked, type: Time, default: nil    # authorization block (if client is blocked)

  #index({redirect_uri:1, code:1}, {unique: true, background: true})

  before_create :random_code
  before_create :create_expiration

  # Check if the authorization is expired
  def expired?
    self.expire_at < Time.now
  end

  private

    # random authorization code
    def random_code
      self.code = SecureRandom.hex(SwtkOauthConfig.settings["random_code_length"])
    end

    # expiration time
    def create_expiration
      self.expire_at = Chronic.parse("in #{SwtkOauthConfig.settings["code_expires_in"]} seconds")
    end

end
