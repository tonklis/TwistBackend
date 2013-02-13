class GamesController < ApplicationController

  def start
    @board = Board.new()
    @board.last_action = params[:user_id]
    @board.detail_xml = params[:detail_xml]
    @board.status = 'NUEVO'
    
    @card_id
    if (params[:card_type] == Template.find_by_description("Amigos").id)
      @card_id = Card.get_friend(params[:card_facebook_id], params[:card_name]).id
    else
      @card_id = params[:card_id]
    end

    @game = Game.new()
    @game.user_id = params[:user_id]
    @game.card_id = @card_id
    @game.question_count = 0
    @game.guess_count = 0

    @opponent_game = Game.new()
    @opponent_game.user_id = User.get_from_facebook_info(params[:opponent_id], params[:opponent_name]).id
    @opponent_game.question_count = 0
    @opponent_game.guess_count = 0  

    respond_to do |format|
      if @board.save
        @game.board_id = @board.id
        @opponent_game.board_id = @board.id
        if @game.save
          @opponent_game.opponent_game_id = @game.id
          if @opponent_game.save
            @game.update_attribute(:opponent_game_id, @opponent_game.id)
            format.json { render json: @game, status: :created, location: @game }
          else
            format.json { render json: @opponent_game.errors, status: :unprocessable_entity }
          end
        else
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      else
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    @card_id
    if (params[:card_type] == Template.find_by_description("Amigos").id)
      @card_id = Card.get_friend(params[:card_facebook_id], params[:card_name]).id
    else
      @card_id = params[:card_id]
    end

    @game = Game.find(params[:id])
    
    respond_to do |format|
      if @game.update_attribute(:card_id, @card_id)
        format.json { render json: @game, status: :updated, location: @game }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :ok }
    end
  end
end
