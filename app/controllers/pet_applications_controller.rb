class PetApplicationsController < ApplicationController

  #create the application & pet asociation 
  def create
    PetApplication.create!(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end
end