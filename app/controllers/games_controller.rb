class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :add_moves]

  SHORT_GAME_VIEW = [:id, :game_type, :game_status, :white_player_id, :black_player_id, :date_started, :date_finished, :actual_game]
  GCM_API_KEY = 'AIzaSyCAPZQ7GDiVXSdLPMeYNhTz6hbO6Q3Rdao'

  def index
    @user_id = params[:user_id]
    #consider moving this logic to service layer
    @user_games = Game.where('white_player_id = :white_player OR black_player_id = :black_player', {white_player: @user_id, black_player: @user_id}).limit(params[:limit]).offset(params[:offset]).order('date_started')
    respond_to do |format|
      format.html {}
      format.json { render json: @user_games, only: SHORT_GAME_VIEW } #filtering output for list of games
    end
  end

  def show
    respond_to do |format|
      format.html {}
      format.json { render json: @game, only: SHORT_GAME_VIEW }
    end
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    respond_to do |format|
      begin
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render json: @game, status: :created }
        else
          format.html { render action: 'new' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :unprocessable_entity }
      end
    end
  end


  def add_moves
    #return error if 'board' request value was not found
    unless params[:board]
      @game.errors.add(:board, 'Moves record was not found. If you are using JSON request body, check that \'Content-Type\' header is set to \'application/json\' value')
      respond_to do |format|
        format.json { render json: @game.errors, status: :bad_request }
      end
      return
    end

    @actual_game_record = @game.actual_game
    @actual_game_record[:board] = params[:board]

    #Obtain opponent registration id
    device = Device.find_by_user_id(params[:user_id])
    #response with error in case device was not found
    unless device
      render json: {error: 'Registration ID error: no device found'}, status: :conflict
      return
    end

    registration_id = device.registration_id

    unless registration_id
      render json: {error: 'Registration ID error: no registration_id found'}, status: :conflict
      return
    end

    #Send update to opponent device
    gcm = GCM.new(GCM_API_KEY)
    registration_ids = [registration_id]
    options = {
        data: {
            game_id: @game.id,
            event: params[:event],
            user_id: params[:user_id],
            board: params[:board]
        }, collapse_key: "updated_move"
    }
    response = gcm.send_notification(registration_ids, options)
    google_response = JSON.parse(response[:body])

    handle_canonical_id(device, google_response) if google_response['canonical_ids'] != 0

    unless response[:response] == 'success' and google_response['failure'] == 0
      #some error occurred
      render json: {error: "GCM error: #{google_response['results'][0]['error']}"}, status: :conflict
      return
    end


    respond_to do |format|
      if @game.update_attributes({actual_game: @actual_game_record, game_status: params[:event]} )
        format.html { redirect_to @game, notice: 'Move was successfully added.' }
        format.json { render json: @game.actual_game, status: :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render json: @game, status: :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to user_games_url }
      format.json { head :no_content }
    end
  end

  private
  def handle_canonical_id(device, google_response )
    device.update_attribute(:registration_id, google_response['results'][0]['registration_id'])
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:event, :site, :date_started, :round, :white_player_id, :black_player_id, :result, :text, :game_type, :actual_game, :game_status).tap do |white_list|
      white_list[:actual_game] = params[:game][:actual_game] #this construction allow us to accept any nested json structure inside :actual_game
    end
  end
end
