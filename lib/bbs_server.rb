require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require_relative 'contribution_operation'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bbs_data.db")
class ContributionInfo
	include DataMapper::Resource
	property :contribution_number, Serial #auto-incrementing key
	property :name, String, :required => true #cannot be null
	property :message, Text, :required => true
	property :write_date, String
end
DataMapper.finalize.auto_upgrade!

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
	ContributionInfo.create(:name => params[:name], :message => params[:message], :write_date => Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	@store = ContributionInfo.all(:order => [:contribution_number.desc])
	@current_page = operation.current_page
	erb :list, :layout => :form
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
