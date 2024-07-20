# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchoolSearch do
  describe "relationships" do
    it { is_expected.to belong_to(:search_school_param) }
    it { is_expected.to belong_to(:school) }
  end
end
