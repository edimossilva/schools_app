# frozen_string_literal: true

module Api
  module V1
    class SchoolsController < Api::V1::ApiController
      skip_before_action :authenticate_devise_api_token!
      skip_after_action :verify_authorized

      def index
        schools = SyncSchools.result(school_index_contract:).data

        render json: schools, status: :ok
      end

      def index_fetch_only
        schools = FetchSchools.result(school_index_contract:).data

        render json: schools, status: :ok
      end

      def index_fetch_and_store_on_db
        schools = SyncSchoolsFromApiOrDb.result(school_index_contract:).data

        render json: schools, status: :ok
      end

      def index_fetch_and_store_on_cache_and_db
        schools = SyncSchoolsFromApiOrDbOrCache.result(school_index_contract:).data.to_a

        render json: schools, status: :ok
      end

      private

      def school_index_contract
        @school_index_contract ||= SchoolContracts::Index.call(permitted_params(:school_name_like, :per_page, :page))
      end
    end
  end
end
