require 'rails_helper'

RSpec.describe 'The admin application show page' do
  before(:each) do
    @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pirate = @aurora.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @aurora.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @aurora.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @app1 = Application.create!(name: "Tucker", street_address: "1122 Blank St.", city: 'New York City', state: "NY", zip_code: "12121", description: "We have one happy dog and would love another!", status: "Pending") 
      
    @petapp1 = PetApplication.create!(pet: @pirate, application: @app1)
    @petapp2 = PetApplication.create!(pet: @clawdia, application: @app1)
    @petapp3 = PetApplication.create!(pet: @lucille, application: @app1)
  end

  it 'has a button to approve a pet' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@pirate.id}") do
      expect(page).to have_button("Approve")
    end
  end

  it 'has a button to reject a pet' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@clawdia.id}") do
      expect(page).to have_button("Reject")
    end
  end

  it 'displays if a pet has been accepted or rejected' do
    visit "/admin/applications/#{@app1.id}"
  end

  it 'pets do not have a button if they have been accepted or rejected' do
  end
end
