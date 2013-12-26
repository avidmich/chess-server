require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe GamesController do

  # This should return the minimal set of attributes required to create a valid
  # Game. As you add validations to Game, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  game_type: "NETWORK", game_status: "IN_PROGRESS", white_player_id: 1, black_player_id: 2} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GamesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) do
    controller.stub(:authenticate).and_return(true)
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET index" do
    it "assigns all games as @games" do
      game = Game.create! valid_attributes
      get :index, {user_id: 1}, valid_session
      assigns(:user_games).should eq([game])
    end
  end

  describe "GET show" do
    it "assigns the requested game as @game" do
      game = Game.create! valid_attributes
      get :show, {:id => game.to_param}, valid_session
      assigns(:game).should eq(game)
    end

    it "renders game data as JSON" do
      game  = Game.create! valid_attributes
      get :show, {id: game.to_param}, valid_session
      JSON.parse(response.body)['id'].should_not eq(nil)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Game" do
        expect {
          post :create, {:game => valid_attributes}, valid_session
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create, {:game => valid_attributes}, valid_session
        assigns(:game).should be_a(Game)
        assigns(:game).should be_persisted
      end

      it "responses 201 Created and returns JSON object" do
        post :create, {:game => valid_attributes}, valid_session
        response.status.should eq(201)
        JSON.parse(response.body)['id'].should_not eq(nil)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        post :create, {:game => { game_status: "UNKNOWN"  }}, valid_session
        assigns(:game).should be_a_new(Game)
      end

      it "responses 400 Bad Request" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        post :create, {:game => {  }}, valid_session
        response.status.should eq(400)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested game" do
        game = Game.create! valid_attributes
        # Assuming there are no other games in the database, this
        # specifies that the Game created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Game.any_instance.should_receive(:update).with({ "game_status" => "params", "actual_game" => "e2-e4" })
        put :update, {:id => game.to_param, :game => { "game_status" => "params", "actual_game" => "e2-e4" }}, valid_session
      end

      it "assigns the requested game as @game" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
        assigns(:game).should eq(game)
      end

      it "resonses 200 OK and renders JSON object" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
        response.status.should eq(200)
        JSON.parse(response.body)['id'].should_not  eq(nil)
      end
    end

    describe "with invalid params" do
      it "assigns the game as @game" do
        game = Game.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        put :update, {:id => game.to_param, :game => {  }}, valid_session
        assigns(:game).should eq(game)
      end

      it "re-renders the 'edit' template" do
        game = Game.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        put :update, {:id => game.to_param, :game => { game_status: 'UNKNOWN'  }}, valid_session
        response.status.should eq(422)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested game" do
      game = Game.create! valid_attributes
      expect {
        delete :destroy, {:id => game.to_param}, valid_session
      }.to change(Game, :count).by(-1)
    end

    it "returns 200 OK and removed game as a JSON" do
      game = Game.create! valid_attributes
      delete :destroy, {:id => game.to_param}, valid_session
      response.status.should ==  200
      JSON.parse(response.body)['id'].should_not eq(nil)
    end
  end

end
