class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :destroy]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all
    respond_to do |format|
      format.json {render json: @feedbacks}
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
   respond_to do |format|
     format.json {render json: @feedback}
   end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.json { render json: @feedback, status: :created }
      else
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    respond_to do |format|
      if @feedback.destroy
        format.json { head :ok }
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feedback_params
    params.require(:feedback).permit(:type, :memo, :app_version, :os_version, :sdk_version, :manufacturer, :model, :username, :email)
  end
end
