require 'sinatra'
require_relative 'bean/contribution_info'
store = []
current_page = 1
start = 0
contribution_number = 0

get '/'  do
	erb :index, :layout => false
end

get '/main' do
	erb :main, :layout => :form
end

post '/write' do
	content = ContributionInfo.new(contribution_number += 1, params[:name], params[:message],Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	store.unshift(content)
	@store = store[0, 10]
	@current_page = current_page
	erb :write, :layout => :form
end

get '/next/:page' do
	en = 10
	start = 10 * current_page + 1
	current_page += 1
	@store =  store[start, en]
	@current_page = current_page
	erb :write, :layout => :form
end

get '/prev' do
	en = 10
	current_page -= 1
	if current_page == 1
		start = 0
	else
		start -=10
	end
	@store = store[start,en]
	@current_page = current_page
	erb :write, :layout => :form
end

