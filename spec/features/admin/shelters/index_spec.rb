require 'rails_helper'

RSpec.describe 'The admin shelters index page' do
  before(:each) do
    @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @rgv = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @fancy = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pirate = @aurora.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)

    @app1 = Application.create!(name: "Tucker", street_address: "1122 Blank St.", city: 'New York City', state: "NY", zip_code: "12121", description: "We have one happy dog and would love another!", status: "Pending") 
    @petapp1 = PetApplication.create!(pet: @pirate, application: @app1)

    visit admin_shelters_path
  end

  it 'has a section that lists all shelters by reverse alphabetical order' do

    within "#index_all" do
      save_and_open_page
      expect(@rgv.name).to appear_before (@fancy.name) 
      expect(@fancy.name).to appear_before (@aurora.name) 
    end
  end

  it 'has a section that lists shelters with pending applications' do
    within "#pending_shelters" do
      expect(page).to have_content(@aurora.name)
      expect(page).to_not have_content(@rgv.name)
    end
  end
end