require 'sinatra'
require_relative 'bean/contribution_info'
store = []

get '/'  do
	erb :index, :layout => false
end

get '/main' do
	erb :main, :layout => :form
end

post '/write' do
	content = ContributionInfo.new(params[:name], params[:message],Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	store << content
	@store = store.clone
	erb :write, :layout => :form
end
