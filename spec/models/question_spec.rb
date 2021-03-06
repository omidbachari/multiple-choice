require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:quiz) }
  it { should have_many(:answers) }
  it { should have_many(:answer_submissions) }

  it { should validate_presence_of(:query) }

  describe "#student_answer" do
    it "returns a student's answer" do
      user = FactoryGirl.create(:user)
      quiz = FactoryGirl.create(:quiz_with_questions)
      question = quiz.questions.first
      FactoryGirl.create(:answer_submission,
        user: user,
        answer: question.correct_answer
      )
      expect(question.student_answer(user)).to eq(question.correct_answer)
    end

    it "returns nil if student has not answered" do
      user = FactoryGirl.create(:user)
      quiz = FactoryGirl.create(:quiz_with_questions)
      question = quiz.questions.first

      expect(question.student_answer(user)).to eq(nil)
    end
  end
end
