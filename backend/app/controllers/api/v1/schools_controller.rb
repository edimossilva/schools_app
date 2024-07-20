# frozen_string_literal: true

module Api
  module V1
    class SchoolsController < Api::V1::ApiController
      skip_before_action :authenticate_devise_api_token!
      skip_after_action :verify_authorized

      def index_fetch_only
        schools_data = FetchSchools.result(school_index_contract:).data
        schools = schools_data.map { School.from_hash(_1) }

        render json: schools, status: :ok
      end

      def index_fetch_and_store_on_db
        schools = SyncSchoolsFromApiOrDb.result(school_index_contract:).data
        render json: schools, status: :ok
      end

      def index_fetch_and_store_on_cache_and_db
        schools = Rails.cache.fetch(school_index_contract.to_s) do
          SyncSchoolsFromApiOrDb.result(school_index_contract:).data.to_a
        end
        render json: schools, status: :ok
      end

      private

      def school_index_contract
        @school_index_contract ||= SchoolContracts::Index.call(permitted_params(:school_name_like, :per_page, :page))
      end
    end
  end
end
