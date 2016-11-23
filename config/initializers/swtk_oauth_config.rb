module SwtkOauthConfig
  def self.settings
    @settings ||= YAML.load_file("#{Rails.root}/config/swtk_oauth.yml")
  end
end
