class User < ApplicationRecord
    has_many :events #userは多くのイベントを持ちます
    has_secure_password #validations: false #<- password暗号化が問題
    validates :password, presence: true
    validates :password, confirmation: { case_sensitive: true }
    
    def self.find_or_create_from_auth(auth)
        logger.debug("Twitter Check!!!!!!!!!")
        
        logger.debug("Twitter Check!!!!!!!!!")
        provider = auth[:provider]
        uid = auth[:uid]
        user_name = auth[:info][:nickname]
        image_url = auth[:info][:image]
    
            
        self.find_or_create_by(provider: provider, uid: uid) do |user|
            #データを検索して、もしなければ生成。
          user.user_name = user_name
          user.image_url = image_url
          user.password = uid
          user.password_confirmation = uid
          logger.debug(user.errors.inspect)
        end
    end
end
