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

  describe 'callbacks' do
    before(:each) do
      @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pirate = @aurora.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @clawdia = @aurora.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @application = Application.create!(name: "Tucker", street_address: "1122 Blank St.", city: 'New York City', state: "NY", zip_code: "12121", description: "We have one happy dog and would love another!", status: "In Progress") 
      @petapp1 = PetApplication.create!(pet: @pirate, application: @application)
      @petapp2 = PetApplication.create!(pet: @clawdia, application: @application)
    end

    it 'triggers update_adoptable if updated' do
      expect(@application).to receive(:update_adoptable)
      @application.update(status: "Accepted")
    end

    it 'will not trigger update_adoptable if status is not Accepted' do
      expect(@application).to_not receive(:update_adoptable)
      @application.update(status: "Pending")
    end

    it 'updates its pets adoptability' do
      expect(Pet.find(@pirate.id).adoptable).to eq(true)
      expect(Pet.find(@clawdia.id).adoptable).to eq(true)
      
      @application.update(status: "Accepted")
      require 'pry'; binding.pry 
      expect(Pet.find(@pirate.id).adoptable).to eq(false)
      expect(Pet.find(@clawdia.id).adoptable).to eq(false)
    end
  end
  
  it 'has a default status value' do
    @new_app = Application.new

    expect(@new_app.status).to_not eq("Approved")
    expect(@new_app.status).to_not eq("Rejected")
    expect(@new_app.status).to_not eq("Pending")

    expect(@new_app.status).to eq("In Progress")
  end
end