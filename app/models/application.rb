class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  attribute :status, :string, default: "In Progress"

  validates_presence_of :name,:street_address,:city,:state
  validates_presence_of  :status, inclusion: ["In Progress","Pending","Accepted","Rejected" ]
  validates_numericality_of :zip_code

  def app_status(verdict)
    self.pet_applications.where(status: verdict).count
  end
end