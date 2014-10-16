require_relative '../contribution_operation'

class ContributionOperationTest
	def initialize
	end

	def next_test(count)
		operation = ContributionOperation.new
		expected_current_page = count + 1 #期待する値　初期値 1 + メソッド回数分
		expected_contribution_number = count #期待する値 初期値 0 + メソッド回数分
		expected_start_message = 10 * count #期待する値 初期値 0 + 10ページ × メソッド回数分
		tmp = count * 100
		tmp.times { |i|
			operation.store << i + 1 #1スタート
		}
		expected_store = operation.store
		count.times{ |i|
			operation.next
		}
		raise "assert current_page expected:#{expected_current_page} actual:#{operation.current_page}" unless expected_current_page === operation.current_page
		raise "assert contribution_number expected:#{expected_contribution_number} actual:#{operation.current_page}" unless expected_contribution_number === operation.contribution_number
		raise "assert start_message expected:#{expected_start_message} actual:#{operation.start_message}" unless expected_start_message === operation.start_message
		raise "assert store expected:#{expected_store[expected_start_message, operation.message_item]} actual:#{operation.store[operation.start_message, operation.message_item]}" unless expected_store[expected_start_message, operation.message_item] === operation.store[operation.start_message, operation.message_item]
		puts "next method green!!"
	end

	def prev_test(count)
		operation = ContributionOperation.new
		tmp = count * 100
		tmp.times { |i|
			operation.next
		}
		#TODO store value test
		expected_current_page = operation.current_page - count #期待する値 現在の状態  - メソッド回数分
		expected_contribution_number =operation.contribution_number - count #期待する値 現在の状態 -メソッド回数分
		expected_start_message = operation.start_message - 10 * count #期待する値 現在の状態 - 10ページ × メソッド回数分
		count.times { |i|
			operation.prev
		}
		raise "assert current_page expected:#{expected_current_page} actual:#{operation.current_page}" unless expected_current_page === operation.current_page
		raise "assert contribution_number expected:#{expected_contribution_number} actual:#{operation.contribution_number}" unless expected_contribution_number === operation.contribution_number
		raise "assert start_message expected:#{expected_start_message} actual:#{operation.start_message}" unless expected_start_message === operation.start_message
		puts "prev method green!!"
	end
end

test = ContributionOperationTest.new
test.next_test(1000)
test.prev_test(100)
