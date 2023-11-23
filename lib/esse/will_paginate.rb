# frozen_string_literal: true

require "esse"
require "will_paginate"
require "will_paginate/collection"

require_relative "will_paginate/version"
require_relative "will_paginate/pagination"

Esse::Search::Query.__send__ :include, Esse::WillPaginate::Pagination::SearchQuery
