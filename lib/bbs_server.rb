require 'sinatra'

get '/'  do
	erb :index
end

get '/main' do
	erb :main
end

post '/write' do
	@name = params[:name]
	@message = params[:message]
	erb :write
end
