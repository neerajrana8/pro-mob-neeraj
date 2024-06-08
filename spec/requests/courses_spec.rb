require 'rails_helper'

RSpec.describe "Courses API", type: :request do
  describe "POST /courses" do
    let(:valid_attributes) do
      {
        course: {
          name: "Physics",
          tutors_attributes: [
            { name: "Dr. Smith" },
            { name: "Prof. Johnson" }
          ]
        }
      }
    end

    let(:invalid_attributes) do
      {
        course: {
          name: "",
          tutors_attributes: [
            { name: "Dr. Smith" },
            { name: "Prof. Johnson" }
          ]
        }
      }
    end

    it "creates a course with tutors" do
      expect {
        post courses_path, params: valid_attributes
      }.to change(Course, :count).by(1)
                                 .and change(Tutor, :count).by(2)

      expect(response).to have_http_status(:created)
    end

    it "does not create a course with invalid attributes" do
      expect {
        post courses_path, params: invalid_attributes
      }.not_to change(Course, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /courses" do
    let!(:course) { create(:course, name: "Mathematics") }
    let!(:tutor) { create(:tutor, name: "Dr. Euler", course: course) }

    it "returns all courses with their tutors" do
      get courses_path

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json[0]['name']).to eq(course.name)
      expect(json[0]['tutors'][0]['name']).to eq(tutor.name)
    end
  end
end