class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_alpha
    @shelters_with_pending = Shelter.shelters_with_pending
  end
end