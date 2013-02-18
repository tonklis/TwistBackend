class UsersController < ApplicationController
  
  def games_by_user
    @games = User.find(params[:id]).games.includes(:board, :user, :opponent_game => :user)
    @games.each do |game|
      @games.delete_at(@games.index(game)) if (game.board.status == "OCULTO" || game.is_hidden?)
    end
    respond_to do |format|
      format.json { render json: @games, :include => {:board => {}, :user => {}, :card => {}, :opponent_game => {:include => :user}} }
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

	def login
		@user = User.login(params[:email], params[:first_name], params[:last_name], params[:facebook_id])
    respond_to do |format|
      format.json { render json: @user }
    end
	end

	def registered
		facebook_ids = params[:facebook_ids].split(",")
		@users = User.registered_users(facebook_ids)
		respond_to do |format|
			format.json { render json: @users }
		end
	end

	def reset_badges
		user = User.find(params[:id])
		user.update_attribute(:badge_number, 0)

		respond_to do |format|
			format.json { render json: user }
    end	
	end

end
