require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
#require_relative 'contribution_operation'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bbs_data.db")
class ContributionInfo
	include DataMapper::Resource
	property :contribution_number, Serial #auto-incrementing key
	property :name, String, :required => true #cannot be null
	property :message, Text, :required => true
	property :write_date, String
end
DataMapper.finalize.auto_upgrade!

first_message = 0
last_message = 0

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
		@store = ContributionInfo.all(:order => [:contribution_number.desc], :limit => 10)
		last_message = @store.last[:contribution_number]
		erb :list, :layout => :form
	else
		erb :account
	end
end

post '/write' do
	ContributionInfo.create(:name => params[:name], :message => params[:message], :write_date => Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	new_message = ContributionInfo.all(:order => [:contribution_number.desc], :limit => 10)
	if new_message.blank?
		new_message = ContributionInfo.all(:order => [:contribution_number.desc], :limit => 10)
	end
	@store = new_message#降順の最新10件
	last_message = @store.last[:contribution_number] 
	erb :list, :layout => :form
end

get '/next' do
	next_message = ContributionInfo.all(:contribution_number.lt => last_message, :order => [:contribution_number.desc], :limit => 10)
	if next_message.blank?
		next_message = ContributionInfo.all(:contribution_number.lt => last_message, :order => [:contribution_number.desc], :limit => 10)
	end
	@store  = next_message
	last_message = @store.last[:contribution_number]
	erb :list, :layout => :form
end