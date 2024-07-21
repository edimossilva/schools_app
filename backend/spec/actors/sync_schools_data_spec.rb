# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncSchoolsData, type: :actor do
  describe ".call" do
    let(:schools_data_json) do
      [
        {
          "school.name" => "Test School",
          "id" => "external_id_1",
          "location.lat" => 12.34,
          "location.lon" => 56.78
        }
      ].to_json
    end

    let(:school_index_contract_json) do
      { key: "value" }.to_json
    end

    let(:search_school_param) { create(:search_school_param) }

    it "returns schools" do
      result = described_class.call(
        schools_data_json: schools_data_json,
        school_index_contract_json: school_index_contract_json
      )

      schools = result.data
      expect(schools.first).to be_a(School)
      expect(schools.first.name).to eq("Test School")
      expect(schools.first).to be_persisted
    end

    it "associate schools with search_school_param" do
      result = described_class.call(
        schools_data_json: schools_data_json,
        school_index_contract_json: school_index_contract_json
      )

      schools = result.data
      expect(schools[0].search_school_params[0].params_as_key).to eq(school_index_contract_json)
    end
  end
end
