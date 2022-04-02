require "rails_helper"

RSpec.describe 'Vehicle' do
  before(:example) do
    @redis = Redis.new
    @redis.keys.each { |key| @redis.del(key) }
  end

  describe '.new' do
    it 'creates new parsed vehicle object' do
      vehicle = Vehicle.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => 'unknown',
        'movies' => ['movie1', 'movie2']
      })
      
      expect(vehicle.name).to eq('Test')
      expect(vehicle.passengers).to eq('10200')
      expect(vehicle.cost_in_credits).to eq('2020')
      expect(vehicle.cargo_capacity).to eq('unknown')
      expect(vehicle.movies).to include('movie1', 'movie2')
    end
  end

  describe '#to_hash' do
    it 'shows hash object with lowest passengers' do
      vehicle = Vehicle.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => '500',
        'movies' => ['url_movie1', 'url_movie2']
      })

      vehicle.movies.each do |url|
        response = double(parsed_response: { 'title' => "#{url}_name" }, success?: true)

        allow(HTTParty).to receive(:get).with(url, verify: false).and_return(response)
      end

      vehicle_hash = vehicle.to_hash('lowest', 'passengers')

      expect(@redis.keys).to include("vehicles_lowest_passengers_movies")
      expect(vehicle_hash[:name]).to eq(vehicle.name)
      expect(vehicle_hash[:passengers]).to eq(10200)
      expect(vehicle_hash[:cost_in_credits]).to eq(2020)
      expect(vehicle_hash[:cargo_capacity]).to eq(500)
      expect(vehicle_hash[:movies]).to include('url_movie1_name', 'url_movie2_name')
    end

    it 'shows hash object with highest passengers' do
      vehicle = Vehicle.new({
        'name' => 'Test',
        'passengers' => '10,200',
        'cost_in_credits' => '20,20',
        'cargo_capacity' => '500',
        'movies' => ['url_movie1', 'url_movie2']
      })

      vehicle.movies.each do |url|
        response = double(parsed_response: { 'title' => "#{url}_name" }, success?: true)

        allow(HTTParty).to receive(:get).with(url, verify: false).and_return(response)
      end

      vehicle_hash = vehicle.to_hash('highest', 'passengers')

      expect(@redis.keys).to include("vehicles_highest_passengers_movies")
      expect(vehicle_hash[:name]).to eq(vehicle.name)
      expect(vehicle_hash[:passengers]).to eq(10200)
      expect(vehicle_hash[:cost_in_credits]).to eq(2020)
      expect(vehicle_hash[:cargo_capacity]).to eq(500)
      expect(vehicle_hash[:movies]).to include('url_movie1_name', 'url_movie2_name')
    end
  end
end