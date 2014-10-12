class ContributionInfo
	attr_reader :contribution_number, :name, :message, :write_date
	def initialize(contribution_number, name, message, write_date)
		@contribution_number = contribution_number
		@name = name
		@message = message
		@write_date = write_date
	end

	def get_contribution_number
		@contribution_number
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
