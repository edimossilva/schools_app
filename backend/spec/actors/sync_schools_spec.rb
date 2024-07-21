# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncSchools, type: :actor do
  describe ".call" do
    let(:school_index_contract) { { page: 1, per_page: 10, school_name_like: "Test School" } }
    let(:search_school_param) { create(:search_school_param) }
    let(:schools_data) do
      [
        { "school.name" => "Test School 1", "id" => "1", "location.lat" => 12.34, "location.lon" => 56.78 },
        { "school.name" => "Test School 2", "id" => "2", "location.lat" => 12.35, "location.lon" => 56.79 }
      ]
    end
    let(:schools) { schools_data.map { |data| School.from_hash(data) } }

    before do
      allow(SyncSearchSchoolParamOnDb).to receive(:result).and_return(OpenStruct.new(data: search_school_param))
      allow(Rails.cache).to receive(:fetch).and_return(nil)
      allow(FetchSchools).to receive(:result).and_return(OpenStruct.new(schools_data: schools_data, data: schools))
    end

    context "when cache is empty and no schools exist" do
      it "calls FetchSchools and enqueues SyncSchoolsJob" do
        expect(Rails.cache).to receive(:fetch).with(search_school_param.params_as_key).and_return(nil)
        expect(FetchSchools).to receive(:result).with(school_index_contract:).and_return(
          OpenStruct.new(
            schools_data: schools_data, data: schools
          )
        )
        expect(SyncSchoolsJob).to receive(:perform_async).with(schools_data.to_json, school_index_contract.to_json)

        result = described_class.call(school_index_contract: school_index_contract)
        expect(result.data).to eq(schools)
      end
    end

    context "when cache is empty but schools exist" do
      let(:search_school_param) do
        search_school_param = create(:search_school_param)
        search_school_param.schools = schools
        search_school_param
      end

      it "returns existing schools without calling FetchSchools" do
        expect(Rails.cache).to receive(:fetch).with(search_school_param.params_as_key).and_return(nil)
        expect(FetchSchools).not_to receive(:result)
        expect(SyncSchoolsJob).not_to receive(:perform_async)

        result = described_class.call(school_index_contract:)
        expect(result.data).to eq(schools)
      end
    end

    context "when schools are cached" do
      before do
        allow(Rails.cache).to receive(:fetch).with(search_school_param.params_as_key).and_return(schools)
      end

      it "returns cached schools without calling FetchSchools or enqueuing SyncSchoolsJob" do
        expect(FetchSchools).not_to receive(:result)
        expect(SyncSchoolsJob).not_to receive(:perform_async)

        result = described_class.call(school_index_contract: school_index_contract)
        expect(result.data).to eq(schools)
      end
    end
  end
end
