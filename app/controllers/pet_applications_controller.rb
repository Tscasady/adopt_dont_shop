class PetApplicationsController < ApplicationController

  def create
    PetApplication.create!(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    @petapp = PetApplication.find(params[:id])
    @petapp.update(status: params[:status])
    redirect_to "/admin/applications/#{@petapp.application_id}"
  end
end