# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Schools" do
  describe "GET /api/v1/schools/index_fetch_only" do
    context "when data is valid" do
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
        ]
      end

      let(:school_index_contract) do
        SchoolContracts::Index.call(params)
      end

      before do
        allow(FetchSchools).to receive(:result).with(school_index_contract:).and_return(result)
        get "/api/v1/schools/index_fetch_only", params:
      end

      it { expect(response.parsed_body).to match(schools) }
    end
  end
end
