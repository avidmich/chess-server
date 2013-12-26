class DevicesController < ApplicationController
  before_action :set_device, only: [:unregister]

  # POST /users/1/register
  def register
    respond_to do |format|
      @device = Device.find_by(device_params)
      if @device
        format.json { render json: {device: @device, message: 'This device is already registered'}, status: :accepted }
      else
        begin
          @device = Device.new(device_params)
          if @device.save
            format.json { render json: @device, status: :created }
          else
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        rescue => ex
          format.json { render json: {error: ex}, status: :unprocessable_entity }
        end
      end
    end
  end

  # POST /users/1/unregister
  def unregister
    respond_to do |format|
      begin
        if @device && @device.destroy
          format.json { render json: @device, status: :ok }
        else
          format.json { render json: {error: 'Device with given registration_id not found or operation could not be processed'}, status: :unprocessable_entity }
        end
      rescue => ex
        format.json { render json: {error: ex}, status: :bad_request }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find_by(registration_id: params[:registration_id], user_id: params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    @permitted_params = params.require(:device).permit(:registration_id)
    @permitted_params[:user_id] = params.require(:user_id)
    @permitted_params
  end
end
