require 'rails_helper'

RSpec.describe StudentAddonsController, type: :controller do

  describe "POST #add_course" do
    let(:student) { FactoryGirl.create(:student) }
    before { sign_in student }
    let(:course) { FactoryGirl.create(:course) }

    context "with valid course" do
      it "adds the course to the student" do
        expect {
          post :add_course, id: student, course: course.attributes
        }.to change(student.courses, :count).by(1)
      end

      it "redirects to the student_root path" do
        post :add_course, id: student, course: course.attributes
        response.should redirect_to(student_root_path)
      end

      context "course already added" do
        before { student.courses << course }

        it "does not add the course to the student" do
          expect {
            post :add_course, id: student, course: course.attributes
          }.to change(student.courses, :count).by(0)
        end

        it "flashes an error message" do
          post :add_course, id: student, course: course.attributes
          expect(flash[:alert]).to match /already added/m
        end
      end
    end

    context "with non-valid course" do
      it "does not add the course to the student" do
        expect {
          post :add_course, id: student, course: {}
        }.to change(student.courses, :count).by 0
      end

      it "flashes an error message" do
        post :add_course, id: student, course: {}
        expect(flash[:alert]).to match /No courses were found/m
      end
    end
  end

  describe "DELETE #leave_course" do
    let(:student) { FactoryGirl.create(:student) }
    before { sign_in student }
    let(:course) { FactoryGirl.create(:course) }
    before(:each) { student.courses << course }

    context "with valid course" do
      it "removes the course from the student" do
        expect {
          delete :leave_course, id: student, course_id: course
        }.to change(student.courses, :count).by(-1)
      end

      it "redirects to the student_root path" do
        delete :leave_course, id: student, course_id: course
        response.should redirect_to(student_root_path)
      end
    end
  end

end
