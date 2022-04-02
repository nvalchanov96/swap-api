require "rails_helper"

RSpec.describe 'Starship' do
  before(:example) do
    @redis = Redis.new
    @redis.keys.each { |key| @redis.del(key) }
  end

  describe '.new' do
    it 'creates new parsed starship object' do
      starship = Starship.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => 'unknown',
        'movies' => ['movie1', 'movie2']
      })
      
      expect(starship.name).to eq('Test')
      expect(starship.passengers).to eq('10200')
      expect(starship.cost_in_credits).to eq('2020')
      expect(starship.cargo_capacity).to eq('unknown')
      expect(starship.movies).to include('movie1', 'movie2')
    end
  end

  describe '#to_hash' do
    it 'shows hash object with lowest passengers' do
      starship = Starship.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => '500',
        'movies' => ['url_movie1', 'url_movie2']
      })

      starship.movies.each do |url|
        response = double(parsed_response: { 'title' => "#{url}_name" }, success?: true)

        allow(HTTParty).to receive(:get).with(url, verify: false).and_return(response)
      end

      starship_hash = starship.to_hash('lowest', 'passengers')

      expect(@redis.keys).to include("starships_lowest_passengers_movies")
      expect(starship_hash[:name]).to eq(starship.name)
      expect(starship_hash[:passengers]).to eq(10200)
      expect(starship_hash[:cost_in_credits]).to eq(2020)
      expect(starship_hash[:cargo_capacity]).to eq(500)
      expect(starship_hash[:movies]).to include('url_movie1_name', 'url_movie2_name')
    end

    it 'shows hash object with highest passengers' do
      starship = Starship.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => '500',
        'movies' => ['url_movie1', 'url_movie2']
      })

      starship.movies.each do |url|
        response = double(parsed_response: { 'title' => "#{url}_name" }, success?: true)

        allow(HTTParty).to receive(:get).with(url, verify: false).and_return(response)
      end

      starship_hash = starship.to_hash('highest', 'passengers')

      expect(@redis.keys).to include("starships_highest_passengers_movies")
      expect(starship_hash[:name]).to eq(starship.name)
      expect(starship_hash[:passengers]).to eq(10200)
      expect(starship_hash[:cost_in_credits]).to eq(2020)
      expect(starship_hash[:cargo_capacity]).to eq(500)
      expect(starship_hash[:movies]).to include('url_movie1_name', 'url_movie2_name')
    end
  end
end