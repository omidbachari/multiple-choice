require 'rails_helper'

feature "Admin Views Attendance Page", %(
As an instructor
I would like to see which students have been active at Launch on a specific day
So that I can take attendance.

Acceptance Criteria:
* [x] I can see a list of absent students on the current date.
* [x] I can see a list of present students on the current date.
* [] I would like to be able to fill in an alternate date to
     view attendence stats on a past date
) do

  scenario "admin views attendence page and sees active students" do
    admin = FactoryGirl.create(:user, role: "admin")
    student = FactoryGirl.create(:user_with_answered_quiz)
    sign_in(admin)

    click_link 'View Attendance'

    expect(page).to have_content("Present")
    expect(page).to have_content(student.name)
  end

  scenario "admin views attendence page and sees inactive students" do
    admin = FactoryGirl.create(:user, role: "admin")
    student = FactoryGirl.create(:user)
    sign_in(admin)

    click_link 'View Attendance'

    expect(page).to have_content("Absent")
    expect(page).to have_content(student.name)
  end

  scenario "admin views attendence page for a past date" do
    admin = FactoryGirl.create(:user, role: "admin")
    Timecop.freeze(Time.local(2015, 2, 10, 9, 0, 0)) do  # 9AM Tuesday
      @student = FactoryGirl.create(:user_with_answered_quiz)
    end

    Timecop.freeze(Time.local(2015, 2, 12, 9, 0, 0)) do  # 9AM Thursday
      sign_in(admin)
      expect(page).to have_no_content(@student.name)

      click_link 'View Attendance'
      fill_in "Date", with: "02/10/2015"
      click_on "Submit"

      expect(page).to have_content(@student.name)
    end
  end
end
