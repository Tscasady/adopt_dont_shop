class ApplicationsController < ApplicationController

  def show 
    @application = Application.find(params[:id])
    @search_result = Pet.search(params[:search]) if params[:search]
  end
  
  def new
    @new_application = Application.new
  end

  def create
    @new_application = Application.create(app_params)
    
    if @new_application.save
      flash.notice = 'Update Successful'
      redirect_to ("/applications/#{@new_application.id}")
    else
      flash.notice = 'Unsuccessful - Please Try Again'
      render :new
    end
  end

  def update
    @application = Application.find(params[:id])
    @application.update!(status: "Pending", bid_reason: params[:bid_reason] )

    redirect_to ("/applications/#{@application.id}")
  end

  private

  def app_params
    params.permit(:name,:street_address,:city,:state,:zip_code,:description,:status,:bid_reason)
  end

end