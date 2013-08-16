class UsersController < ApplicationController
  
  def games_by_user

    game_ids = []
    latest_games = ActiveRecord::Base.connection.execute("select max(g1.board_id) as board from games g1, games g2,  boards b where g1.opponent_game_id = g2.id and g1.board_id = b.id and g1.user_id = " + params[:id] +" and g1.is_hidden = false AND b.status != 'OCULTO' group by g2.user_id") 
    latest_games.each do |game|
      game_ids.push(game["board"])
    end

    @show_games = User.find(params[:id]).games.where("games.board_id in (?)", game_ids).includes(:board, :user, :opponent_game => :user).order("boards.status", "boards.last_action", "games.updated_at")
    previous_games = ActiveRecord::Base.connection.execute("select max(g1.board_id) as board, b.status, b.winner_id, b.last_action, g1.is_hidden as game1, g2.is_hidden as game2, g2.user_id as opponent from games g1, games g2,  boards b where g1.opponent_game_id = g2.id and g1.board_id = b.id and g1.user_id = " + params[:id] + " and g1.is_hidden = false AND (b.status = 'ABANDONO' OR b.status = 'FINALIZO' ) and g1.board_id not in (" + game_ids.join(',') + ") group by g2.user_id, b.status, b.winner_id, b.last_action, game1, game2, opponent")
    
    puts "diego 1 " + @show_games.length
    puts "diego 2 " + previous_games.length

    @show_games.each do |game|
      #if game.board.status == 'NUEVO'
        previous_games.each do |p_game|
          if game.opponent_game.user_id == p_game["opponent"]
            if p_game["status"] == "FINALIZO"
              if p_game["winner_id"] == game.user_id
                game["previous_result"] = 0
              else
                game["previous_result"] = 1
              end
            elsif p_game["status"] == "ABANDONO"
              game["previous_result"] = 2
            end
          end
        end
      #end
    end

    new_games_received = []
    new_games_sent = []
    my_turn_games = []
    their_turn_games = []
    won_games = []
    lost_games = []
    quit_games = []

    @show_games.each do |game|
      new_games_received.push(game) if (game.board.status == "NUEVO" && game.board.last_action != game.user_id)
      new_games_sent.push(game) if (game.board.status == "NUEVO" && game.board.last_action == game.user_id)
      my_turn_games.push(game) if (game.board.status == "TURNO" && game.board.last_action != game.user_id)
      their_turn_games.push(game) if (game.board.status == "TURNO" && game.board.last_action == game.user_id)
      won_games.push(game) if (game.board.status == "FINALIZO" && game.board.winner_id == game.user_id)
      lost_games.push(game) if (game.board.status == "FINALIZO" && game.board.winner_id != game.user_id)
      quit_games.push(game) if (game.board.status == "ABANDONO")
    end

    @show_games = new_games_received + my_turn_games + new_games_sent + their_turn_games + won_games + lost_games + quit_games

    respond_to do |format|
      format.json { render json: @show_games, :include => {:board => {}, :user => {}, :card => {}, :opponent_game => {:include => :user}} }
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
