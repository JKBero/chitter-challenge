require 'sinatra/base'
require_relative 'lib/peep.rb'
require_relative 'lib/user.rb'

class Chitter < Sinatra::Base

  enable :sessions, :method_override

  get '/' do
    @peeps = Peep.all
    @user = session[:user]
    erb :index, { :layout => :layout }
  end

  post '/' do
    session[:user] = User.create(user_name: params['name'],
      user_handle: params['user-handle'], email: params['email'],
      password: params['password'])
    if session[:user] == :email_clash || session[:user] == :handle_clash
      redirect '/'
    else
      redirect '/user'
    end
  end

  get '/user' do
    @peeps = Peep.all
    @user = session[:user]
    erb :user, { :layout => :layout }
  end

  post '/user' do
    Peep.create(content: params['content'], user_id: session[:user].user_id)
    redirect '/user'
  end

  get '/log-in' do
    @user = session[:user]
    @error = session[:error]
    session[:error] = false
    erb :log_in, { :layout => :layout }
  end

  post '/log-in' do
    session[:user] = User.authenticate(email: params['email'], password: params['password'])
    if session[:user]
      redirect '/user'
    else
      session[:error] = true
      redirect '/log-in'
    end
  end

  delete '/post/:id' do
    Peep.delete(id: params[:id])
    redirect '/user'
  end

  get '/post/:id/edit' do
    @user = session[:user]
    @peep_id = params[:id]
    @peep_content = Peep.find_content(id: params[:id])
    erb :edit
  end

  patch '/post/:id' do
    Peep.update(content: params['content'], id: params[:id])
    redirect '/user'
  end

  get '/log-out' do
    erb :log_out, { :layout => :layout }
  end

  post '/log-out' do
    session.clear
    redirect '/log-out'
  end

  run! if app_file == $0

end
