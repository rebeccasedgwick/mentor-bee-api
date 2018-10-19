require "rails_helper"

RSpec.describe MenteesController, type: :request do
  let!(:mentees) { create_list(:mentee, 5) }

  describe "GET /mentees" do
    before { get "/mentees" }

    it "returns mentees" do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /mentees/:id" do
    let(:mentee) { create(:mentee) }

    context "request is valid" do
      before { get "/mentees/#{mentee.id}" }
      it "returns mentees" do
        expect(json["interest"]).to eq(mentee.interest)
      end
    end
    context "request is invalid" do
      before { get "/mentees/0" }
      it "returns a failure message" do
        expect(response.body).to eq("{\"message\":\"Couldn't find Mentee\"}")
      end
      it "returns status code 422" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /mentees" do
    let(:user) { create(:user) }
    let(:valid_attributes) { { mentee: { user_id: user.id, bio: "Expecto Patronum", interest: "Lumos" } } }
    let(:invalid_attributes) { { mentee: { user_id: user.id, bio: "Expecto Patronum" } } }

    context "request is valid" do
      before { post "/mentees", params: valid_attributes }
      it "creates a mentee" do
        expect(json["interest"]).to eq("Lumos")
      end
      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "request is invalid" do
      before { post "/mentees", params: invalid_attributes }
      it "returns a failure message" do
        expect(response.body).to eq("{\"message\":\"Validation failed: Interest can't be blank\"}")
      end
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end
end