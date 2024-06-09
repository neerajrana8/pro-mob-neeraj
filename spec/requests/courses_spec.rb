require 'rails_helper'

RSpec.describe "Courses API", type: :request do
  describe "POST /courses" do
    let(:valid_attributes) do
      {
        course: {
          name: "Physics",
          tutors_attributes: [
            { name: "Dr. Rana" },
            { name: "Dr. Singh" }
          ]
        }
      }
    end

    let(:invalid_attributes) do
      {
        course: {
          name: "",
          tutors_attributes: [
            { name: "Dr. Rana" },
            { name: "Dr. Singh" }
          ]
        }
      }
    end

    let(:invalid_tutor_attributes) do
      {
        course: {
          name: "Chemistry",
          tutors_attributes: [
            { name: "" },
            { name: "Dr. Singh" }
          ]
        }
      }
    end

    context "when the request is valid" do
      before { post courses_path, params: valid_attributes }

      it "creates a course" do
        expect(Course.count).to eq(1)
      end

      it "creates the associated tutors" do
        expect(Tutor.count).to eq(2)
        expect(Course.first.tutors.pluck(:name)).to include("Dr. Rana", "Dr. Singh")
      end

      it "returns the created course with tutors" do
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Physics')
        expect(json['tutors'].size).to eq(2)
        expect(json['tutors'][0]['name']).to eq('Dr. Rana')
        expect(json['tutors'][1]['name']).to eq('Dr. Singh')
      end

      it "returns a status code of 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when the course attributes are invalid" do
      before { post courses_path, params: invalid_attributes }

      it "does not create a course" do
        expect(Course.count).to eq(0)
      end

      it "does not create any tutors" do
        expect(Tutor.count).to eq(0)
      end

      it "returns error messages" do
        json = JSON.parse(response.body)
        expect(json['name']).to include("can't be blank")
      end

      it "returns a status code of 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the tutor attributes are invalid" do
      before { post courses_path, params: invalid_tutor_attributes }

      it "does not create a course" do
        expect(Course.count).to eq(0)
      end

      it "does not create any tutors" do
        expect(Tutor.count).to eq(0)
      end

      it "returns error messages" do
        json = JSON.parse(response.body)
        expect(json['tutors.name']).to include("can't be blank")
      end

      it "returns a status code of 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # Get API tests

  describe "GET /courses" do
    let(:course_attributes) do
      {
        course: {
          name: "Physics",
          tutors_attributes: [
            { name: "Dr. Rana" },
            { name: "Dr. Singh" }
          ]
        }
      }
    end
    before { post courses_path, params: course_attributes }
    before { get courses_path }

    it "returns all courses with their tutors" do
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)

      expect(json[0]['name']).to eq('Physics')
      expect(json[0]['tutors'].size).to eq(2)
      expect(json[0]['tutors'][0]['name']).to eq('Dr. Rana')
      expect(json[0]['tutors'][1]['name']).to eq('Dr. Singh')
    end

    it "returns a status code of 200" do
      expect(response).to have_http_status(:ok)
    end
  end
end