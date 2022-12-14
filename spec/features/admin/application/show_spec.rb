require 'rails_helper'

RSpec.describe 'The admin application show page' do
  before(:each) do
    @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pirate = @aurora.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @aurora.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @aurora.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @app1 = Application.create!(name: "Tucker", street_address: "1122 Blank St.", city: 'New York City', state: "NY", zip_code: "12121", description: "We have one happy dog and would love another!", status: "In Progress") 
    @app2 = Application.create!(name: "Sara", street_address: "2211 Other St.", city: 'Iowa City', state: "IA", zip_code: "33434", description: "Give pet please", status: "In Progress") 
    @app3 = Application.create!(name: "Joe", street_address: "2 Corner St.", city: 'Bolder', state: "CO", zip_code: "05728", description: "Need friends") 
    
    @petapp1 = PetApplication.create!(pet: @pirate, application: @app1)
    @petapp2 = PetApplication.create!(pet: @clawdia, application: @app1)
    @petapp3 = PetApplication.create!(pet: @lucille, application: @app1)
    @petapp4 = PetApplication.create!(pet: @pirate, application: @app2)
    @petapp5 = PetApplication.create!(pet: @clawdia, application: @app2)
    @petapp6 = PetApplication.create!(pet: @lucille, application: @app2)
    @petapp7 = PetApplication.create!(pet: @pirate, application: @app3)
  end

  it 'has buttons to approve or reject a pet' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@pirate.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end

    within("##{@clawdia.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'displays if a pet has been accepted or rejected' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@pirate.id}") do
      click_button "Approve"

      expect(page).to have_content("Approved")
    end

    within("##{@clawdia.id}") do
      click_button "Reject"

      expect(page).to have_content("Rejected")
    end
  end

  it 'pets do not have a button if they have been accepted or rejected' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@pirate.id}") do
      click_button "Approve"

      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end

    within("##{@clawdia.id}") do
      click_button "Reject"

      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end
  end

  it 'does not change the status of a pet on a different application' do
    visit "/admin/applications/#{@app1.id}"

    within("##{@pirate.id}") do
      click_button "Approve"

      expect(page).to have_content("Approved")
    end

    visit "/admin/applications/#{@app2.id}"

    within("##{@pirate.id}") do
      expect(page).to_not have_content("Approved")
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  describe 'when all pets on an application are approved or rejected' do
    before(:each)do
      visit "/admin/applications/#{@app2.id}"

      within("##{@pirate.id}") do
        click_button "Approve"
      end
      
      within("##{@clawdia.id}") do
        click_button "Approve"
      end
    end
    
    it 'returns the user to the admin application show page if approved' do
      within("##{@lucille.id}") do
        click_button "Approve"
      end
      
      expect(current_path).to_not eq("/applications/#{@app2.id}")
      expect(current_path).to eq("/admin/applications/#{@app2.id}")
    end

    it 'returns the user to the admin application show page if rejected' do
      within("##{@lucille.id}") do
        click_button "Reject"
      end
      
      expect(current_path).to_not eq("/applications/#{@app2.id}")
      expect(current_path).to eq("/admin/applications/#{@app2.id}")
    end

    it "changes the application's status to 'Approved' " do
      within("##{@lucille.id}") do
        click_button "Approve"
      end
      
      expect(page).to_not have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Rejected')
      expect(page).to have_content('Application Status: Accepted')
    end

    it "changes the application's status to 'Rejected' " do
      within("##{@lucille.id}") do
        click_button "Reject"
      end

      expect(page).to_not have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Accepted')
      expect(page).to have_content('Application Status: Rejected')
    end
  end
  
  describe 'Pets can only have one approved application on them at any time' do
    describe "'Pending' application with an adopted pet" do       
      before(:each)do
        visit "/admin/applications/#{@app3.id}"
        within("##{@pirate.id}") do
          click_button "Approve"
        end
      end
      
      it 'displays a notice that the pet is adopted and a button to reject the pet' do 
                
        within("##{@pirate.id}") do
          expect(page).to_not have_button("Approve")
          expect(page).to_not have_button("Reject")
        end

        visit "/admin/applications/#{@app1.id}"
        within("##{@pirate.id}") do
          expect(page).to_not have_button("Approve")
        
          expect(page).to have_content("This pet is adopted")
          expect(page).to have_button("Reject")
        end
        
        within("##{@lucille.id}") do
          expect(page).to_not have_content("This pet is adopted")
        
          expect(page).to have_button("Approve")
          expect(page).to have_button("Reject")
        end
        
        within("##{@clawdia.id}") do
          expect(page).to_not have_content("This pet is adopted")
          
          expect(page).to have_button("Approve")
          expect(page).to have_button("Reject")
        end   
      end     
    end
  end
end