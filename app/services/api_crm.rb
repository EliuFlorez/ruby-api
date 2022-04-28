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