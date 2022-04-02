require 'rails_helper'

RSpec.describe Services::SwapApiRequest do
  describe '.fetch_data' do
    before(:example) do
      @redis = Redis.new
      @redis.keys.each { |key| @redis.del(key) }
    end

    it 'fetch data from all pages' do
      data = []
      response1 = double(success?: true, parsed_response: {"results"=>[{ "name"=>"Test1", "passngers": "10" }], "next"=>"?page=2"})
      response2 = double(success?: true, parsed_response: {"results"=>[{ "name"=>"Test2", "passngers": "20"}]})
      allow(HTTParty).to receive(:get).with("#{Services::SwapApiRequest::BASE_URI}/starships/?page=1", verify: false).and_return(response1) 
      allow(HTTParty).to receive(:get).with("#{Services::SwapApiRequest::BASE_URI}/starships/?page=2", verify: false).and_return(response2) 

      Services::SwapApiRequest.fetch_data('starships', data)

      expect(data.size).to eq 2
      expect(data.first["name"]).to eq "Test1"
      expect(data.last["name"]).to eq "Test2"
    end

    it 'returns error' do
      data = []
      response1 = double(success?: false, parsed_response: {"results"=>[{ "name"=>"Test1", "passngers": "10" }], "next"=>"?page=2"})
      allow(HTTParty).to receive(:get).with("#{Services::SwapApiRequest::BASE_URI}/starships/?page=1", verify: false).and_return(response1) 

      Services::SwapApiRequest.fetch_data('starships', data)

      expect(data.size).to eq 0
    end
  end
end