class CrmProvider
	class << self
		def oauth(type)
			case type
			when "hubspot"
				Hubspot::Oauth
			else
				raise StandardError.new "Error Oauth: type has an invalid value (#{type})"
			end
		end
	end
end

class ApiCrm
	class << self
		def contacts(type)
			case type
			when "hubspot"
				Hubspot::Contact
			else
				raise StandardError.new "Error Oauth: type has an invalid value (#{type})"
			end
		end
	end
end