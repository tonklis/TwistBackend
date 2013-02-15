class GamesController < ApplicationController

  def last_turn
    @turn = Turn.where("game_id = ?", params[:id]).last
    respond_to do |format|
      format.json { render json: @turn}
    end
  end

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
    @board = Board.find(@game.board_id)
    @board.update_attribute(:status, "TURNO")

    respond_to do |format|
      if @game.update_attribute(:card_id, @card_id)
        format.json { render json: @game}
      else
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def ask
    @game = Game.find(params[:id])
    @opponent_game = Game.find(@game.opponent_game_id)
    @board = Board.find(@game.board_id)

    respond_to do |format|
      @turn = Turn.create(:game_id => @game.id, :is_guess => 0, :question => params[:question])
      
      @game.update_attribute(:question_count, @game.question_count + 1)

      @board.update_attributes(:status => "TURNO", :last_action => @game.user_id, :detail_xml => params[:detail_xml])

      @last_turn = Turn.where("game_id = ?", @opponent_game.id).last
      if @last_turn && @last_turn.is_guess == false
        @last_turn.update_attribute(:answer, params[:answer])
      end

      format.json { render json: @game, :include => {:board => {}} }
    end
  end

  def guess
    @game = Game.find(params[:id])
    @opponent_game = Game.find(@game.opponent_game_id)
    @board = Board.find(@game.board_id)

    respond_to do |format|
      @turn = Turn.create(:game_id => @game.id, :is_guess => 1)
      
      @game.update_attribute(:guess_count, @game.guess_count + 1)

      @last_turn = Turn.where("game_id = ?", @opponent_game.id).last
      if @last_turn && @last_turn.is_guess == false
        @last_turn.update_attribute(:answer, params[:answer])
      end
      
      if (@opponent_game.card_id == params[:card_id])
        @board.update_attributes(:status => "FINALIZO", :last_action => @game.user_id, :detail_xml => params[:detail_xml], :winner_id => @game.user_id)
      else
        @board.update_attributes(:status => "TURNO", :last_action => @game.user_id, :detail_xml => params[:detail_xml])
      end

      format.json { render json: @game, :include => {:board => {}} }
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
