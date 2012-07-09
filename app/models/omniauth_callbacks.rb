# coding: utf-8  
class User
  module OmniauthCallbacks
    
    ["github","google","twitter","facebook"].each do |provider|
      define_method "find_or_create_for_#{provider}" do |response|
        uid = response["uid"]
        data = response["info"]

        if user = User.includes("authorizations").where("authorizations.provider" => provider , "authorizations.uid" => uid).first
          user
        elsif user = User.find_by_email(data["email"])
          user.bind_service(response)
          user
        else 
          user = User.new_from_provider_data(provider,uid,data)

          if user.save(:validate => false)
            user.authorizations << Authorization.new(:provider => provider, :uid => uid )
            return user
          else
            Rails.logger.warn("User.create_from_hash 失败，#{user.errors.inspect}")
            return nil
          end
        end
        
      end
    end
     
    
    def new_from_provider_data(provider, uid, data)

      user = User.new
      user.email = data["email"]
      user.email = "twitter+#{uid}@example.com" if provider == "twitter"
      user.email = "douban+#{uid}@example.com" if provider == "douban"
      
      user.name = data["nickname"]
      user.name = data["name"] if provider == "google"
      user.name.gsub!(/[^\w]/, "_") unless user.name.blank?
      if User.where(:name => user.name).count > 0 || user.name.blank?
        user.name = "u#{Time.now.to_i}"
      end
      
      user.password = Devise.friendly_token[0,20]
      user.current_sign_in_ip = data["location"]
      user.description = data["description"]
      
      if provider == "facebook" && user.avatar.blank?
        require "open-uri"
        file = File.open("#{uid}.png", "wb");
        file << open("http://graph.facebook.com/#{uid}/picture?type=large").read
        user.avatar = file
        user.save!
        File.delete(file)
        file.close
      end
      
      return user
    end
  end
end