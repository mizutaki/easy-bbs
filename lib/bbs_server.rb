require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require 'logger'
require 'fileutils'
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bbs_data.db")
class ContributionInfo
	include DataMapper::Resource
	property :contribution_number, Serial #auto-incrementing key
	property :title, String
	property :name, String, :required => true #cannot be null
	property :message, Text, :required => true
	property :write_date, String
end
DataMapper.finalize.auto_upgrade!

first_message = 0
last_message = 0
current_page = 0
FileUtils.mkdir('logs') unless FileTest.exist?('logs')
log = Logger.new("logs/access.log")

get '/'  do
	erb :index, :layout => false
end

post '/login' do
	log.debug(@env["REQUEST_URI"])
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
		p @store
		if @store.nil? == false
			first_message = @store.first[:contribution_number]
			last_message = @store.last[:contribution_number]
		end
		current_page = 1
		@current_page = current_page
		erb :list, :layout => :form
	else
		erb :account
	end
end

post '/write' do
	log.debug(@env["REQUEST_URI"])
	log.debug(params)
	if params[:title].empty?
		 params[:title] = 'notitle'
	end
	ContributionInfo.create(:title => params[:title], :name => params[:name], :message => params[:message], :write_date => Time.now.strftime('%Y/%m/%d %H:%M:%S'))
	new_message = ContributionInfo.all(:order => [:contribution_number.desc], :limit => 10)
	if new_message.blank?
		new_message = ContributionInfo.all(:order => [:contribution_number.desc], :limit => 10)
	end
	@store = new_message#降順の最新10件
	first_message = @store.first[:contribution_number]
	last_message = @store.last[:contribution_number]
	current_page = 1
	@current_page = current_page
	erb :list, :layout => :form
end

get '/next' do
	log.debug(@env["REQUEST_URI"])
	next_message = ContributionInfo.all(:contribution_number.lt => last_message, :order => [:contribution_number.desc], :limit => 10)
	if next_message.blank?
		next_message = ContributionInfo.all(:contribution_number.lt => last_message, :order => [:contribution_number.desc], :limit => 10)
	end
	@store  = next_message
	first_message = @store.first[:contribution_number]
	last_message = @store.last[:contribution_number]
	current_page += 1
	@current_page = current_page
	erb :list, :layout => :form
end

get '/prev' do
	log.debug(@env["REQUEST_URI"])
	prev_message = ContributionInfo.all(:contribution_number.gt => first_message, :limit => 10)
	if prev_message.blank?
		prev_message = ContributionInfo.all(:contribution_number.gt => first_message, :limit => 10)
	end
	reverse = []
	prev_message.each do |message|
		reverse.unshift(message)
	end
	@store = reverse
	first_message = @store.first[:contribution_number]
	last_message = @store.last[:contribution_number]
	if current_page != 1
		current_page -=1
		@current_page = current_page
	end
	erb :list, :layout => :form
end
