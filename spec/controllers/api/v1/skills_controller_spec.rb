require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :request do

 before do 
  admin_user = User.create!(name: "Testing User", email: "testing@bestpeers.com", password: "123456", type: "Admin", custom_authentication_token: "testing@123", confirmed_at: Date.today, unconfirmed_email: nil)
  @admin_token = admin_user.custom_authentication_token

  employee_user = User.create!(name: "Testing User 2", email: "testing1@bestpeers.com", password: "123456", type: "Employee", custom_authentication_token: "testingToken@123", confirmed_at: Date.today, unconfirmed_email: nil)
  @employee_token = employee_user.custom_authentication_token
 end


 # For Valid attributes :- 

  describe "GET #index" do
    before do
      Skill.create(name: "Java Skill")

      get "/api/v1/skills", headers: { "Authorization" => @admin_token }
    end

    # let means syntax to declare new variable like javascripts
    let(:response_keys) {
      ["id","name"]
      }

    it "returns http success" do    # This is block to run
      expect(response).to have_http_status(:success)
    end

    it "JSON body for valid attributes" do  # This is block to run
      expect(JSON.parse(response.body).count).to eq(1)  # eq means equivalent to or equal to
      expect(JSON.parse(response.body).first["name"]).to eq("Java Skill")
      expect(JSON.parse(response.body).first.keys).to eq(response_keys)
      expect(response.status).to eq(200)
    end
  end


#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------
 # For Valid attributes :- 

  describe "GET #show" do
    before do 
      Skill.create(name: "Java Skill")

      get "/api/v1/skills/1", headers: { "Authorization" => @admin_token }
    end

    let(:my_response_keys) {
      [:id,:name]
      }

    it "returns http success" do    # This is block to run
      expect(response).to have_http_status(:success)
    end

    it "JSON body for Show valid attributes" do  # This is block to run

      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:name]).to eq('Java Skill')
      expect(json.count).to eq(2)
      expect(json.keys).to eq(my_response_keys)
      expect(response.status).to eq(200)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

 # For Valid attributes :- 

  describe "POST #create" do
    before do  
      post "/api/v1/skills", params: {
            skill: {
              name: 'Ruby Created'
            }
          }, headers: { "Authorization" => @admin_token }
    end

    let(:my_response_keys) {
      [:id,:name]
      }

    it "returns http success" do    # This is block to run
      expect(response).to have_http_status(:success)
    end

    it "JSON body for Create valid attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:name]).to eq('Ruby Created')
      expect(json.count).to eq(2)
      expect(json.keys).to eq(my_response_keys)
      expect(response.status).to eq(200)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# For Valid attributes :- 
  describe "PUT #update" do
    before do
    
      Skill.create(name: "Before Update Skill")
       
      put "/api/v1/skills/1", params: {
            skill: {
              name: 'Ruby Updated'
            }
          }, headers: { "Authorization" => @admin_token }
    end

    let(:my_response_keys) {
      [:id,:name,:message]
      }

    it "returns http success" do    # This is block to run
        expect(response).to have_http_status(:success)
    end

    it "JSON body for Update valid attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:name]).to eq('Ruby Updated')
      expect(json[:message]).to eq('Skill Sucessfully Updated')
      expect(json.count).to eq(3)
      expect(json.keys).to eq(my_response_keys)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------
 
# For Valid attributes :- 

  describe "Destroy #destroy" do
    before do

      Skill.create(name: "Sample Skill for delete")
      
      delete "/api/v1/skills/1", headers: { "Authorization" => @admin_token }
    end

    let(:my_response_keys) {
      [:message]
      }

    it "To check response status" do    # This is block to run
        expect(response.status).to eq(200)
    end

    it "JSON body for Delete valid attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:message]).to eq('Skill Deleted Succesfully')
      expect(json.count).to eq(1)
      expect(json.keys).to eq(my_response_keys)
    end
  end


#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# For Invalid Token Authentication attributes :- 

  describe "GET #index" do
    invalid_token = "xyz@123" #Invalid Token created
    before do
      Skill.create(name: "Java Skill")

      get "/api/v1/skills", headers: { "Authorization" => invalid_token }
    end

    it "JSON body for Invalid Token Authentication" do  # This is block to run
      expect(JSON.parse(response.body)).to eq("unauthorized")  # eq means equivalent to or equal to
      expect(response.status).to eq(403)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# For Invalid Create missing params attributes :-

  describe "POST #create" do
    before do  
      post "/api/v1/skills", params: {
            skill: {
              name: ''
            }
          }, headers: { "Authorization" => @admin_token }
    end

    it "JSON body for Invalid Create missing params attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:error]).to eq('Unable to create Skill.')
      expect(response.status).to eq(400)
    end
  end


#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# For Invalid Create duplicate skill name attributes :-

  describe "POST #create" do
    before do
      Skill.create(name: 'Ruby on Rails')
      
      post "/api/v1/skills", params: {
            skill: {
              name: 'Ruby on Rails'
            }
          }, headers: { "Authorization" => @admin_token }
    end

    it "JSON body for Invalid Create duplicate skill name attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:error]).to eq('Unable to create Skill.')
      expect(response.status).to eq(400)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# ****************************  Permission Denied *****************************************

# Employee has no permissions to Create, Update, Delete.
# Employee have permissions to Index, Show only.

# Admin has all permisions to CRUD.


# For Invalid Permissions to Create by Employee attributes :-

  describe "POST #create" do
    before do

      post "/api/v1/skills", params: {
            skill: {
              name: 'Advance Java'
            }
          }, headers: { "Authorization" => @employee_token }
    end

    it "JSON body for Invalid Create Permission from Employee attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:message]).to eq('You are Employee, So you dont have permission')
      expect(response.status).to eq(403)
    end
  end



#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

# For Invalid Permissions to Update by Employee attributes  :- 
  describe "PUT #update" do
    before do

      Skill.create(name: "Before Update Skill")
      
      put "/api/v1/skills/1", params: {
            skill: {
              name: 'Ruby Updated'
            }
          }, headers: { "Authorization" => @employee_token }
    end

    it "JSON body for Invalid Update Permission from Employee attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:message]).to eq('You are Employee, So you dont have permission')
      expect(response.status).to eq(403)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------
 
# For Invalid Permissions to Destroy by Employee attributes :- 

  describe "Destroy #destroy" do
    before do

      Skill.create(name: "Sample Skill for delete")
      
      delete "/api/v1/skills/1", headers: { "Authorization" => @employee_token }
    end

    it "JSON body for Invalid Destroy Permission from Employee attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:message]).to eq('You are Employee, So you dont have permission')
      expect(response.status).to eq(403)
    end
  end


end
