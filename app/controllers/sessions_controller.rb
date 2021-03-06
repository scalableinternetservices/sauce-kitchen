class SessionsController < ApplicationController
  def new
    user = current_user
    if user &&  user == User.find_by(id: session[:user_id])
      redirect_to user
    end
  end

  def create
    user = User.find_by(username: params[:session][:username]) || User.find_by(email: params[:session][:username])
  	if (user && user.password_auth?(params[:session][:password]))
  		login user
  		flash[:success] = "Login Successful!"
  		redirect_to user
  	else
  		flash.now[:danger] = "Invalid username/password combination"
  		render 'new'
  	end
  end

  def destroy
  	if logout
  		flash[:success] = "Successfully logged out"
  	end
  	redirect_to root_url
  end

	def logout
		if User.find_by(id: session[:user_id]) 
			session.delete(:user_id)
			true
		else
			false
		end
	end

	def current_user
		User.find_by(id: session[:user_id])
	end
end
