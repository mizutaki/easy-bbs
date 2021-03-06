class ContributionOperation
	attr_accessor :current_page, :contribution_number, :start_message, :message_item, :store
	def initialize
		@store = []
		@current_page = 1
		@contribution_number = 0
		@start_message = 0
		@message_item = 10
	end

	def next
		@contribution_number += 1
		@current_page += 1
		@start_message += 10
		@store[start_message, message_item]
	end

	def prev
		return if current_page == 1
		@contribution_number -= 1
		@current_page -= 1
		@start_message -= 10
		@store[start_message, message_item]
	end
end
