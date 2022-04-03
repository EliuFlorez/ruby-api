class SearchProvider
	class << self
		def oauth(type)
			case type
			when "linkedin"
				Linkedin::Oauth
			else
				raise StandardError.new "Error Search: type has an invalid value (#{type})"
			end
		end
	end
end