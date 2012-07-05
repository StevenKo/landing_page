Facebooker2.load_facebooker_yaml

FACEBOOK_CONFIG = YAML.load_file("#{Rails.root}/config/facebooker.yml")[Rails.env]