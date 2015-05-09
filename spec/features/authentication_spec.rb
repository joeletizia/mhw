require "rails_helper"

describe "Authentication" do subject { page }

  describe "user registration" do

    describe "students" do
      before { visit new_student_registration_path }

      context "with invalid information" do
        before { click_button "Sign up" }
        it { should have_title("Sign up") }
        it { should have_content("can't be blank") }
      end

      context "with valid information" do
        let(:user) { FactoryGirl.attributes_for(:user) }
        before do
          fill_in "Name", with: user[:name]
          fill_in "Email", with: user[:email]
          fill_in "Password", with: user[:password], match: :prefer_exact
          fill_in "Password confirmation", with: user[:password_confirmation],
            match: :prefer_exact
          click_button "Sign up"
        end

        it { should have_link("Sign out", href: destroy_user_session_path) }
        it { should_not have_link("Sign in") }
        it { should have_title("#{user[:first_name]} #{user[:last_name]}") }

        describe "followed by sign out" do
          before { first(:link, "Sign out").click }
          it { should have_link("Sign up") }
        end
      end
    end

    describe "teachers" do
      before { visit new_teacher_registration_path }

      context "with invalid information" do
        before { click_button "Sign up" }
        it { should have_title("Sign up") }
        it { should have_content("can't be blank") }
      end

      context "with valid information" do
        let(:user) { FactoryGirl.attributes_for(:user) }
        before do
          fill_in "Name", with: user[:name]
          fill_in "Email", with: user[:email]
          fill_in "Password", with: user[:password], match: :prefer_exact
          fill_in "Password confirmation", with: user[:password_confirmation],
            match: :prefer_exact
          click_button "Sign up"
        end

        it { should have_link("Sign out", href: destroy_user_session_path) }
        it { should_not have_link("Sign in") }
        it { should have_title("#{user[:first_name]} #{user[:last_name]}") }

        describe "followed by sign out" do
          before { first(:link, "Sign out").click }
          it { should have_link("Sign up") }
        end
      end
    end
  end

  describe "user login" do
    before { visit new_user_session_path }

    describe "students" do

      context "with invalid information" do
        before { click_button "Sign in" }

        it { should have_title("Sign in") }
        it { should have_content("Invalid") }
      end

      context "with valid information" do
        let(:student) { FactoryGirl.create(:student) }

        before do
          fill_in "Email", with: student.email
          fill_in "Password", with: student.password
          click_button "Sign in"
        end

        it { should have_title(full_name(student)) }
        it { should have_link("Sign out") }
        it { should_not have_link("Sign in") }
      end
    end

    describe "teachers" do

      context "with invalid information" do
        before { click_button "Sign in" }

        it { should have_title("Sign in") }
        it { should have_content("Invalid") }
      end

      context "with valid information" do
        let(:teacher) { FactoryGirl.create(:teacher) }

        before do
          fill_in "Email", with: teacher.email
          fill_in "Password", with: teacher.password
          click_button "Sign in"
        end

        it { should have_title(full_name(teacher)) }
        it { should have_link("Sign out") }
        it { should_not have_link("Sign in") }
      end
    end
  end
end
