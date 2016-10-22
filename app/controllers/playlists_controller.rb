class PlaylistsController < ApplicationController
  def show
  	if (@playlist = Playlist.find_by(id: params[:id]))
      @user = current_user
      @playlist_owner = @playlist.user
      if @playlist.private && @user != @playlist_owner
        flash[:info] = "The playlist you tried to access is private"
        redirect_to root_url
      end
    else
      flash[:warning] = "The playlist you tried to access no longer exists"
      redirect_to root_url
    end 
  end

  def show_user_playlists
    @playlists = Playlist.where(user_id: params[:id])
    @user = User.find_by(id: params[:id])
    render 'playlists/user_playlists'
  end

  def new
  	@playlist = Playlist.new
  end

  def create
  	@playlist = Playlist.new(playlist_params)
  	user = User.find_by(id: session[:user_id])
  	@playlist.user = user
  	if @playlist.save
  		redirect_to @playlist
  	else
  		flash.now[:danger] = "Error creating playlist"
  		render 'playlists/new'
  	end
  end

  def update
    @playlist = Playlist.find_by(id: params[:id])
    @playlist.title = params[:playlist][:title]
    @playlist.save
    redirect_to @playlist
  end

  def poll
    playlist = Playlist.find_by(id: params[:id])
    data = playlist ? { :title => playlist.title, 
                        :owner => playlist.user.id, 
                        :psongs => playlist.psongs, 
                        :songs => playlist.songs} : nil
    render :json => data
  end

  private
  	def playlist_params
      params.require(:playlist).permit(:title, :songs, :longitude, :latitude, :private)
  	end
end
