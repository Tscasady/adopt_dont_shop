class Admin::ApplicationsController < ApplicationController
    def show
      @application = Application.find(params[:id])
      @petapps = @application.pet_applications
    end
end