require 'rails_helper'

RSpec.describe AnswerSubmission, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should belong_to(:answer) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:answer) }

  describe "#valid_location?" do
    it "should return true if IP is in a valid location" do
      answer = FactoryGirl.create(:answer_submission)

      expect(answer.valid_location?).to eq(true)
    end
  end

  it "should raise an error if IP is in an invalid location" do
    answer = FactoryGirl.build(:answer_submission, ip: "10.0.0.256")
    answer.save

    expect(answer.errors.full_messages).to include("Ip must be local to Launch Academy to answer a quiz.")
  end

  describe "#valid_time" do
    it "should return true if creation time is during workday" do
      Timecop.freeze(Time.local(2015, 2, 10, 9, 0, 0)) do  # 9AM Tuesday
        answer = FactoryGirl.create(:answer_submission)

        expect(answer.valid_time?).to eq(true)
      end
    end
  end

  it "should raise an error if creation time is during evening" do
    Timecop.freeze(Time.local(2015, 2, 10, 22, 0, 0)) do  # 10PM Tuesday
      answer = FactoryGirl.build(:answer_submission)
      answer.save

      expect(answer.errors.full_messages).to include("Created at must be during the work day")
    end
  end

  it "should raise an error if creation time is during weekend" do
    Timecop.freeze(Time.local(2015, 2, 14, 9, 0, 0)) do  # 9AM Saturday
      answer = FactoryGirl.build(:answer_submission)
      answer.save

      expect(answer.errors.full_messages).to include("Created at must be during the work day")
    end
  end
end
