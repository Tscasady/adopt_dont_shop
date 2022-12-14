class PetApplicationsController < ApplicationController

  def create
    PetApplication.create!(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    @petapp = PetApplication.find(params[:id])
    @petapp.update(status: params[:status])

    @application = @petapp.application
    @petapps = @application.pet_applications

    if @application.app_status("Rejected") > 0
      @application.update(status: "Rejected")
    elsif @application.app_status("Approved") == @petapps.count
      @application.update(status: "Accepted")
    end
   redirect_to "/admin/applications/#{@petapp.application_id}"
  end
end