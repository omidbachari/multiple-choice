require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:quiz) }
  it { should have_many(:answers) }
  it { should have_many(:answer_submissions) }

  it { should validate_presence_of(:query) }
end
