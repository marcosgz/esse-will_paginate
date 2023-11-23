# frozen_string_literal: true

module Esse
  module WillPaginate
    module Pagination
      module SearchQuery
        def self.included(base)
          base.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # Define the `paginate` WillPaginate method
            #
            # @param [Hash] options
            # @option options [Integer] :page
            # @option options [Integer] :per_page
            # @return [Esse::WillPaginate::SearchQuery]
            def paginate(options = {})
              curr_page = ::WillPaginate::PageNumber(options[:page] || 1)
              limit_val = (options[:per_page] || ::WillPaginate.per_page).to_i
              offset_val = (curr_page - 1) * limit_val
              limit(limit_val).offset(offset_val)
            end
          RUBY
        end

        def paginated_results
          page = (offset_value / limit_value.to_f).ceil + 1
          ::WillPaginate::Collection.create(page, limit_value, response.total) do |pager|
            pager.replace response.hits
          end
        end
      end
    end
  end
end
