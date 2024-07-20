# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncSchoolsOnDb, type: :actor do
  describe "#call" do
    subject(:call) { described_class.call(schools_data:, search_school_param:) }

    let(:new_school_data) do
      {
        "school.name" => "New School",
        "id" => "123456",
        "location.lat" => 35.6895,
        "location.lon" => 139.6917
      }
    end
    let(:existing_school_data) do
      {
        "school.name" => "Existing School",
        "id" => "166027",
        "location.lat" => 42.374471,
        "location.lon" => -71.118313
      }
    end
    let(:schools_data) { [new_school_data, existing_school_data] }
    let(:search_school_param) { create(:search_school_param) }

    context "when no school exists" do
      it "creates both schools" do
        expect { call }.to change(School, :count).by(2)
      end

      it "associates schools and search_school_param" do
        schools = call.data
        expect(schools.map(&:search_school_params).flatten).to eq([search_school_param, search_school_param])
      end
    end

    context "when only one school exists" do
      before do
        create(:school, external_id: "166027", name: "Existing School", lat: "42.374471", lng: "-71.118313")
      end

      it "creates only one school" do
        expect { call }.to change(School, :count).by(1)
      end

      it "returns 2 schools" do
        expect(call.data.count).to eq(2)
      end

      it "associates schools and search_school_param" do
        schools = call.data
        expect(schools.map(&:search_school_params).flatten).to eq([search_school_param, search_school_param])
      end
    end
  end
end
