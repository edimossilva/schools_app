# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchSchools, type: :actor do
  describe ".call" do
    let(:school_name) { "The best school" }
    let(:school_index_contract) do
      SchoolContracts::Index.call(
        school_name_like: school_name,
        page: 0,
        per_page: 10
      )
    end

    context "when setup is valid" do
      let(:valid_params) do
        {
          api_key:,
          fields: "id,school.name,location",
          page: 0,
          per_page: 10,
          "school.name" => school_name
        }
      end

      let(:success_response) { { results: schools_data }.to_json }

      let(:schools_data) do
        [
          { "id" => "1",
            "school.name" => school_name,
            "location.lat" => 42.374471,
            "location.lon" => -71.118313 }.transform_keys(&:to_sym)
        ]
      end

      let(:schools) do
        build_list(
          :school, 1, external_id: 1, name: school_name, lat: "42.374471", lng: "-71.118313",
          payload: schools_data[0]
        )
      end

      let(:api_key) { "secret_api_key" }

      before do
        allow(ENV).to receive(:fetch).and_return(api_key)
        stub_request(:get, described_class::FETCH_SCHOOLS_URL)
          .with(query: valid_params)
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "is successful" do
        result = described_class.result(school_index_contract:)
        expect(result.success?).to be true
      end

      it "returns schools list" do
        result = described_class.result(school_index_contract:)
        expect(result.data[0].external_id).to eq(schools[0].external_id)
        expect(result.data.length).to eq(1)
      end
    end

    context "when setup is not valid" do
      context "when api_key is nil" do
        before do
          allow_any_instance_of(described_class).to receive(:api_key).and_return("")
        end

        it "is failure" do
          result = described_class.result(school_index_contract:)
          expect(result.failure?).to be true
        end

        it "returns error object" do
          result = described_class.result(school_index_contract:)
          expect(result.error).to eq(:missing_college_score_card_api_key)
        end
      end
    end
  end
end
