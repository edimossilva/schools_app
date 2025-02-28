# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Schools" do
  describe "GET /api/v1/schools/index_fetch_only" do
    let(:result) { double("Result", data: schools) }
    let(:school_name_like) { "Harvard" }
    let(:params) do
      {
        school_name_like:,
        page: 0,
        per_page: 10
      }
    end

    let(:schools) do
      build_list(:school, 1, external_id: 1, name: school_name_like, lat: "42.374471", lng: "-71.118313")
    end

    let(:school_index_contract) do
      SchoolContracts::Index.call(params)
    end

    before do
      allow(FetchSchools).to receive(:result).with(school_index_contract:).and_return(result)
      get "/api/v1/schools/index_fetch_only", params:
    end

    it "returns school json formatted" do
      expected_response = [{
        id: nil,
        external_id: 1,
        name: school_name_like,
        lat: "42.374471",
        lng: "-71.118313"
      }.with_indifferent_access
]
      expect(response.parsed_body).to match(expected_response)
    end
  end

  describe "GET /api/v1/schools/index_fetch_and_store_on_db" do
    let(:do_request) { get "/api/v1/schools/index_fetch_and_store_on_db", params: }

    context "when there is no search_school_param" do
      let(:result) { double("Result", data: schools) }
      let(:school_name_like) { "Harvard" }
      let(:params) do
        {
          school_name_like:,
          page: 0,
          per_page: 10
        }
      end
      let(:schools) do
        [
          { "id" => "1",
            "school.name" => school_name_like,
            "location.lat" => 42.374471,
            "location.lon" => -71.118313 }
        ].map { School.from_hash(_1) }
      end

      let(:school_index_contract) do
        SchoolContracts::Index.call(params)
      end

      before do
        allow(FetchSchools).to receive(:result).with(school_index_contract:).and_return(result)
        get "/api/v1/schools/index_fetch_and_store_on_db", params:
      end

      it "returns school json formatted" do
        expected_response = [{
          id: School.first.id,
          external_id: 1,
          name: school_name_like,
          lat: "42.374471",
          lng: "-71.118313"
        }.with_indifferent_access
      ]
        expect(response.parsed_body).to match(expected_response)
      end
    end

    context "when there is search_school_param" do
      let(:school_name_like) { "Harvard" }
      let(:params) do
        {
          school_name_like:,
          page: 0,
          per_page: 10
        }
      end
      let(:search_school_param) do
        create(
          :search_school_param, params: school_index_contract, params_as_key: school_index_contract.to_json,
          schools:
        )
      end
      let(:schools) { create_list(:school, 2) }

      let(:school_index_contract) { SchoolContracts::Index.call(params) }

      before do
        search_school_param
      end

      it "returns ok" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "does not call FetchSchools.result" do
        expect(FetchSchools).not_to receive(:result)
        do_request
      end
    end
  end

  describe "GET #index_fetch_and_store_on_cache_and_db" do
    let(:do_request) { get "/api/v1/schools/index_fetch_and_store_on_cache_and_db", params: }

    let(:school_index_contract) do
      SchoolContracts::Index.call(params)
    end

    let(:schools) { create_list(:school, 1) }

    let(:school_name_like) { "Harvard" }
    let(:params) do
      {
        school_name_like:,
        page: 0,
        per_page: 10
      }
    end

    it "returns data from SyncSchools" do
      allow(SyncSchoolsFromApiOrDb).to receive(:result).with(school_index_contract:)
        .and_return(OpenStruct.new(data: schools))
      do_request
      expect(response.parsed_body[0][:id]).to eq(schools[0].id)
    end
  end

  describe "GET #index" do
    let(:do_request) { get "/api/v1/schools", params: }

    let(:school_index_contract) do
      SchoolContracts::Index.call(params)
    end

    let(:schools) { create_list(:school, 1) }

    let(:school_name_like) { "Harvard" }
    let(:params) do
      {
        school_name_like:,
        page: 0,
        per_page: 10
      }
    end

    it "returns data from SyncSchools" do
      allow(SyncSchools).to receive(:result).with(school_index_contract:).and_return(OpenStruct.new(data: schools))
      do_request
      expect(response.parsed_body[0][:id]).to eq(schools[0].id)
    end
  end
end
