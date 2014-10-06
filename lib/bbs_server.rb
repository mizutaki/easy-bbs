require 'sinatra'

store = []

get '/'  do
	erb :index
end

get '/main' do
	erb :main
end

post '/write' do
	content = {}
	content[:name] = params[:name]
	content[:message] = params[:message]
	store << content
	@store = store.clone
	erb :write
end
