require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :request do

 before do 
  admin_user = User.create!(name: "Testing User", email: "testing@bestpeers.com", password: "123456", type: "Admin", custom_authentication_token: "testing@123", confirmed_at: Date.today, unconfirmed_email: nil)
  @my_token = admin_user.custom_authentication_token
 end

  describe "GET #index" do
    before do
      Skill.create(name: "Java Skill")

      get "/api/v1/skills", headers: { "Authorization" => @my_token }
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

  describe "POST #create" do
    before do  
      post "/api/v1/skills", params: {
            skill: {
              name: 'Ruby Created'
            }
          }, headers: { "Authorization" => @my_token }
    end

    let(:my_response_keys) {
      [:id,:name]
      }

    it "returns http success" do    # This is block to run
      expect(response).to have_http_status(:success)
    end

    it "JSON body for valid attributes" do  # This is block to run
      byebug
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:name]).to eq('Ruby Created')
      expect(json.count).to eq(2)
      expect(json.keys).to eq(my_response_keys)
      expect(response.status).to eq(200)
    end
  end

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

  describe "PUT #create" do
    before do
    
      Skill.create(name: "Before Update Skill")
       
      put "/api/v1/skills/1", params: {
            skill: {
              name: 'Ruby Updated'
            }
          }, headers: { "Authorization" => @my_token }
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

  describe "Destroy #destroy" do
    before do

      Skill.create(name: "Sample Skill for delete")
      
      delete "/api/v1/skills/1", headers: { "Authorization" => @my_token }
    end

    let(:my_response_keys) {
      [:message]
      }

    it "To check response status" do    # This is block to run
        expect(response.staus).to eq(200)
    end

    it "JSON body for Delete valid attributes" do  # This is block to run
      json = JSON.parse(response.body).deep_symbolize_keys # This line parse body to json type and converts into symbol

      expect(json[:message]).to eq('Skill Deleted Succesfully')
      expect(json.count).to eq(1)
      expect(json.keys).to eq(my_response_keys)
    end
  end

end
