require 'spec_helper'

describe Review do
  it { should validate_presence_of(:rating) }
  it { should validate_numericality_of(:rating).only_integer }
  it { should validate_presence_of(:content) }
  it { should belong_to(:video) }
  it { should belong_to(:user) }
end
