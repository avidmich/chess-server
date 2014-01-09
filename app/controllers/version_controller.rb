class VersionController < ApplicationController
  def version
    respond_to do |format|
        if params[:version] == '0.0.0'
          format.json { render json: 'UPDATE_REQUIRED', status: :ok }
        else
          format.json { render json: 'UPDATE_NOT_REQUIRED', status: :ok }
        end
    end
  end
end