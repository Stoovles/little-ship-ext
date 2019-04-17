require "rails_helper"

RSpec.describe Review, type: :model do

  describe "Relationships" do
    it {should belong_to :user}
    it {should belong_to :item}
  end



end
