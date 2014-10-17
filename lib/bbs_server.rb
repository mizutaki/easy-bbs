require 'sinatra'
require_relative 'bean/contribution_info'
require_relative 'contribution_operation'

operation = ContributionOperation.new

get '/'  do
	erb :index, :layout => false
end

get '/login' do
	username = false
	password = false
	if params[:username] =~ /admin/ #dummy
		username = true
	end
	if params[:password] =~/admin/ #dummy
		password = true
	end
	if username && password
		erb :main, :layout => :form
	else
		erb :account
	end
end

post '/write' do
	content = ContributionInfo.new(operation.contribution_number += 1, params[:name], params[:message],Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	operation.store.unshift(content)
	@store = operation.store[0, 10]
	@current_page = operation.current_page
	erb :write, :layout => :form
end

get '/next/:page' do
	@store  = operation.next
	@current_page = operation.current_page
	erb :write, :layout => :form
end

get '/prev' do
	@store = operation.prev
	@current_page = operation.current_page
	erb :write, :layout => :form
end
