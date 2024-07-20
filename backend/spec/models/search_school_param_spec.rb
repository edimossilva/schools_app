# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchSchoolParam do
  subject { build(:search_school_param) }

  describe "relationships" do
    it { is_expected.to have_many(:school_searches) }
    it { is_expected.to have_many(:schools).through(:school_searches) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:params) }
    it { is_expected.to validate_uniqueness_of(:params_as_key) }
  end
end
