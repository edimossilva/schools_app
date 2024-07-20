# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncSearchSchoolParamOnDb, type: :actor do
  subject(:actor) { described_class }

  let(:school_name) { "The best school" }
  let(:valid_contract) do
    SchoolContracts::Index.call(
      school_name_like: school_name,
      page: 0,
      per_page: 10
    )
  end

  let(:invalid_contract) { nil }

  describe ".call" do
    context "when SearchSchoolParam does not exist" do
      it "creates a SearchSchoolParam record" do
        expect do
          actor.call(school_index_contract: valid_contract)
        end.to change(SearchSchoolParam, :count).by(1)
      end

      it "sets the data output to the created record" do
        result = actor.call(school_index_contract: valid_contract)
        expect(result.data).to be_a(SearchSchoolParam)
        expect(result.data.params).to eq(valid_contract.with_indifferent_access)
        expect(result.data.params_as_key).to eq(valid_contract.to_s)
      end
    end

    context "when SearchSchoolParam does exists" do
      let!(:search_school_param) do
        create(:search_school_param, params: valid_contract, params_as_key: valid_contract.to_s)
      end

      it "does not create a SearchSchoolParam record" do
        expect do
          actor.call(school_index_contract: valid_contract)
        end.not_to change(SearchSchoolParam, :count)
      end

      it "sets the data output to the existing record" do
        result = actor.call(school_index_contract: valid_contract)
        expect(result.data).to eq(search_school_param)
      end
    end
  end
end
