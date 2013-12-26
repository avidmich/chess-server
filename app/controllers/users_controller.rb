class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  def index
    @users = User.all

    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def show

    @user = if params[:id]
              User.find(params[:id])
            elsif params[:email]
              User.find_by_email(params[:email])
            elsif params[:gplus_id]
              User.find_by_gplus_id(params[:gplus_id])
            else
              raise 'There is no parameters to search for User: no id or email specified'
            end


    respond_to do |format|
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html {}
      format.json { render json: @user }
    end
  end

  def create
    respond_to do |format|
      begin
        @user = User.new(user_params)
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :bad_request }
      end
    end
  end

  def update
    respond_to do |format|
      begin
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render json: @user, status: :ok }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex, message: ex.message}, status: :bad_request }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.destroy
        format.json { head :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :gplus_id)
  end
end
