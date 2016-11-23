class Oauth::Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :token
  field :expire_at, type: Time, default: nil  # token expiration

  index({_id:1}, {background: true})
  index({name:1, host_uid:1}, {unique: true, background: true})

  validates :name, presence: true, uniq: true
  validates :token, presence: true
  validates :expire_at, presence: true

end
