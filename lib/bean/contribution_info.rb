class ContributionInfo

	attr_reader :name, :message, :write_date
	def initialize(name, message, write_date)
		@name = name
		@message = message
		@write_date = write_date
	end

	def get_name
		@name
	end
	
	def get_message
		@message
	end

	def get_write_date
		@write_date
	end
end
