class InviteToken < ActiveRecord::Base

	def self.generate_token
		SecureRandom.urlsafe_base64(25, true)
	end

end