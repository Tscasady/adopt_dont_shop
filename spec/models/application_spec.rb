require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pet_applications) }
    it { should have_many(:pets).through(:pet_applications) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_numericality_of(:zip_code) }
    it { should validate_presence_of(:status) }
  end
  
  it 'has a default status value' do
    @new_app = Application.new

    expect(@new_app.status).to_not eq("Approved")
    expect(@new_app.status).to_not eq("Rejected")
    expect(@new_app.status).to_not eq("Pending")

    expect(@new_app.status).to eq("In Progress")
  end
end