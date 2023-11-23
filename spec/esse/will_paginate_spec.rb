# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esse::WillPaginate do
  before do
    stub_esse_index(:cities)
  end

  it "has a version number" do
    expect(Esse::WillPaginate::VERSION).not_to be_nil
  end

  describe ".paginate" do
    it { expect(CitiesIndex.search("*")).to respond_to(:paginate) }

    it "returns a Search::Query" do
      expect(CitiesIndex.search("*").paginate).to be_a(Esse::Search::Query)
    end

    it "returns a Search::Query with the correct offset" do
      original_per_page = ::WillPaginate.per_page
      WillPaginate.per_page = 17
      expect(CitiesIndex.search("*").paginate.offset_value).to eq(0)
      expect(CitiesIndex.search("*").paginate(page: 2).offset_value).to eq(17)
      expect(CitiesIndex.search("*").paginate(page: 3).offset_value).to eq(34)
      WillPaginate.per_page = original_per_page
    end

    it "returns a Search::Query with the correct limit" do
      expect(CitiesIndex.search("*").paginate.limit_value).to eq(::WillPaginate.per_page)
      expect(CitiesIndex.search("*").paginate(per_page: 15).limit_value).to eq(15)
    end

    it "returns a Search::Query with the correct limit and offset" do
      query = CitiesIndex.search("*").paginate(per_page: 15, page: 2)
      expect(query.limit_value).to eq(15)
      expect(query.offset_value).to eq(15)
    end
  end

  describe "#paginated_results" do
    context "when the search query has results" do
      before do
        expect(CitiesIndex).to esse_receive_request(:search).with(q: "*", from: 0, size: 5).and_return(
          "hits" => {
            "total" => {
              "value" => 100,
              "relation" => "eq"
            },
            "hits" => [{}] * 5
          }
        )
      end

      it "returns a WillPaginate::Collection" do
        query = CitiesIndex.search("*", from: 0, size: 5)
        expect(query.paginated_results).to be_a(::WillPaginate::Collection)
        expect(query.paginated_results.size).to eq(5)
        expect(query.paginated_results.total_entries).to eq(100)
        expect(query.paginated_results.total_pages).to eq(20)
        expect(query.paginated_results.current_page).to eq(1)
        expect(query.paginated_results.per_page).to eq(5)
        expect { |b| query.paginated_results.each(&b) }.to yield_control.exactly(5).times
      end

      it "returns a WillPaginate::Collection using paginate method" do
        query = CitiesIndex.search("*").paginate(page: 1, per_page: 5)
        expect(query.paginated_results).to be_a(::WillPaginate::Collection)
        expect(query.paginated_results.size).to eq(5)
        expect(query.paginated_results.total_entries).to eq(100)
        expect(query.paginated_results.total_pages).to eq(20)
        expect(query.paginated_results.current_page).to eq(1)
        expect(query.paginated_results.per_page).to eq(5)
        expect { |b| query.paginated_results.each(&b) }.to yield_control.exactly(5).times
      end
    end

    context "when the search query has no results" do
      before do
        expect(CitiesIndex).to esse_receive_request(:search).with(q: "*", from: 0, size: 5).and_return(
          "hits" => {
            "total" => {
              "value" => 0,
              "relation" => "eq"
            },
            "hits" => []
          }
        )
      end

      it "returns a WillPaginate::Collection" do
        query = CitiesIndex.search("*", from: 0, size: 5)
        expect(query.paginated_results).to be_a(::WillPaginate::Collection)
        expect(query.paginated_results.size).to eq(0)
        expect(query.paginated_results.total_entries).to eq(0)
        expect(query.paginated_results.current_page).to eq(1)
        expect(query.paginated_results.per_page).to eq(5)
        expect { |b| query.paginated_results.each(&b) }.not_to yield_control
      end

      it "returns a WillPaginate::Collection using paginate method" do
        query = CitiesIndex.search("*").paginate(page: 1, per_page: 5)
        expect(query.paginated_results).to be_a(::WillPaginate::Collection)
        expect(query.paginated_results.size).to eq(0)
        expect(query.paginated_results.total_entries).to eq(0)
        expect(query.paginated_results.current_page).to eq(1)
        expect(query.paginated_results.per_page).to eq(5)
        expect { |b| query.paginated_results.each(&b) }.not_to yield_control
      end
    end
  end
end
