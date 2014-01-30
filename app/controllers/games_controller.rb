class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy, :add_moves]

  SHORT_GAME_VIEW = [:id, :game_type, :game_status, :white_player_id, :black_player_id, :date_started, :date_finished, :actual_game]
  GCM_API_KEY = 'AIzaSyCAPZQ7GDiVXSdLPMeYNhTz6hbO6Q3Rdao'
  GAME_TERMINATION_EVENTS = %w(WHITE_RESIGNED BLACK_RESIGNED WHITE_WON BLACK_WON)

  def index
    @user_id = params[:user_id]
    #consider moving this logic to service layer
    @user_games = Game.where('white_player_id = :white_player OR black_player_id = :black_player', {white_player: @user_id, black_player: @user_id}).limit(params[:limit]).offset(params[:offset]).order('date_started')
    respond_to do |format|
      format.json { render json: @user_games, only: SHORT_GAME_VIEW } #filtering output for list of games
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @game, only: SHORT_GAME_VIEW }
    end
  end

  def create
    respond_to do |format|
      begin
        @game = Game.new(game_params)
        if @game.save
          opponent_id = params[:opponent_id]
          if opponent_id
            devices = Device.where(user_id: opponent_id)
            registration_ids = devices.pluck(:registration_id)
            #response with error in case device was not found
            if registration_ids and registration_ids.any?
              #Send update to opponent device
              game_initiator = find_opponent @game, opponent_id
              options = {
                  data: {
                      game_id: @game.id,
                      event: 'NEW_GAME',
                      opponent_id: game_initiator.id,
                      opponent_first_name: game_initiator.first_name,
                      opponent_last_name: game_initiator.last_name,
                      board: params[:board]
                  }, collapse_key: 'new_game'
              }
              send_gcm_notification(devices, registration_ids, options)
            end
          end

          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render json: @game, status: :created }
        else
          format.html { render action: 'new' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :bad_request }
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
    if params[:board] == @actual_game_record[:board]
      render json: @game.actual_game, status: :ok
      return
    end
    @actual_game_record[:board] = params[:board]

    #Obtain opponent registration id
    opponent_id = params[:opponent_id]
    devices = Device.where(user_id: opponent_id)
    registration_ids = devices.pluck(:registration_id)
    #response with error in case device was not found

    if registration_ids and registration_ids.any?
      #opponent here is the player who sent current request, but opponent_id is his opponent unique identifier
      opponent = find_opponent @game, opponent_id
      options = {
          data: {
              game_id: @game.id,
              event: params[:event],
              opponent_id: opponent.id,
              opponent_first_name: opponent.first_name,
              opponent_last_name: opponent.last_name,
              board: params[:board]
          }, collapse_key: 'updated_move'
      }
      #Send update to opponent device
      google_response, response = send_gcm_notification(devices, registration_ids, options)

      unless response[:response] == 'success' and google_response['failure'] == 0 or google_response['success'] > 0
        #some error occurred
        render json: {error: "GCM error: #{google_response['results'].select { |f| f['error'] }}"}, status: :conflict
        return
      end
    end
    respond_to do |format|
      attributes_to_update = {actual_game: @actual_game_record, game_status: params[:event]}
      if GAME_TERMINATION_EVENTS.include?(params[:event])
        attributes_to_update[:date_finished] = Time.now
      end
      if @game.update_attributes(attributes_to_update)
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
      begin
        if @game.update(game_params)
          format.html { redirect_to @game, notice: 'Game was successfully updated.' }
          format.json { render json: @game, status: :ok }
        else
          format.html { render action: 'edit' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :bad_request }
      end
    end
  end

  def destroy
    respond_to do |format|
      begin
        if @game.destroy
          format.json { render json: @game, status: :ok }
        else
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :bad_request }
      end
    end
  end

  private
  def send_gcm_notification(devices, registration_ids, message_payload)
    gcm = GCM.new(GCM_API_KEY)
    response = gcm.send_notification(registration_ids, message_payload)
    google_response = JSON.parse(response[:body])
    handle_canonical_ids(devices, registration_ids, google_response) if google_response['canonical_ids'] != 0
    return google_response, response
  end

  def find_opponent(game, user_id)
    game.white_player.id == user_id.to_i ? game.black_player : game.white_player
  end

  def handle_canonical_ids(devices, registration_ids, google_response)
    if (devices || []).each_index do |i|
      canonical_id = google_response['results'][i]['registration_id']
      if canonical_id
        if registration_ids.include?(canonical_id)
          #this means that we already have canonical_id stored in database, so it is just enough to remove old registration id from db
          devices[i].destroy
        else
          #if there is no right registration_id in database, we have to update current registration id, that is obsolete with the new one, that was provided by google
          devices[i].update_attribute(:registration_id, canonical_id)
        end
      end
    end
    end
  end

  def set_game
    @game = find_game
  end

  def find_game
    Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:event, :site, :date_started, :round, :white_player_id, :black_player_id, :result, :text, :game_type, :actual_game, :game_status).tap do |white_list|
      white_list[:actual_game] = params[:game][:actual_game] #this construction allow us to accept any nested json structure inside :actual_game
    end
  end
end
