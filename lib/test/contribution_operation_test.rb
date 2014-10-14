require_relative '../contribution_operation'

class ContributionOperationTest
	def initialize
	end

	def next_test(count)
		operation = ContributionOperation.new
		expected = count + 1 #期待する値　初期値 1 + メソッド回数分
		count.times{ |i|
			operation.next
		}
		raise "assert current_page expected:#{expected} actual:#{operation.current_page}" unless expected === operation.current_page
		puts "green!!"
	end

	def prev_test(count)
		#TODO Write TEST
		puts "green!!"
	end
end

test = ContributionOperationTest.new
test.next_test(100)