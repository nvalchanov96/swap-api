require "rails_helper"

RSpec.describe 'Analytics' do
  before(:example) do
    @redis = Redis.new
    @redis.keys.each { |key| @redis.del(key) }

    @starship1 = Starship.new({
      "name"=>"CR90 corvette",
      "passengers"=>"600",
      "cost_in_credits"=>"3500000",
      "cargo_capacity"=>"3000000",
      "movies"=>[
        "https://swapi.dev/api/films/1/",
        "https://swapi.dev/api/films/3/",
        "https://swapi.dev/api/films/6/"
      ]
    })
    @starship2 = Starship.new({
      "name"=>"Star Destroyer",
      "passengers"=>"n/a",
      "cost_in_credits"=>"150000000",
      "cargo_capacity"=>"36000000",
      "movies"=>[
        "https://swapi.dev/api/films/1/",
        "https://swapi.dev/api/films/2/",
        "https://swapi.dev/api/films/3/"
      ]
    })
    @starship3 = Starship.new({
      "name"=>"Sentinel-class landing craft",
      "passengers"=>"75",
      "cost_in_credits"=>"240000",
      "cargo_capacity"=>"180000",
      "movies"=>[
        "https://swapi.dev/api/films/1/"
      ]
    })
    @vehicle1 = Vehicle.new({
      "name"=>"Vehicle1",
      "passengers"=>"n/a",
      "cost_in_credits"=>"150000000",
      "cargo_capacity"=>"36000000",
      "movies"=>[
        "https://swapi.dev/api/films/1/",
        "https://swapi.dev/api/films/2/",
        "https://swapi.dev/api/films/3/"
      ]
    })
    @vehicle2 = Vehicle.new({
      "name"=>"Vehicle2",
      "passengers"=>"75",
      "cost_in_credits"=>"240000",
      "cargo_capacity"=>"180000",
      "movies"=>[
        "https://swapi.dev/api/films/1/"
      ]
    })
    @starship_result = [@starship1, @starship2, @starship3]
    @vehicle_result = [@vehicle1, @vehicle2]
    @starship3_to_hash = {
      "name"=>"Sentinel-class landing craft",
      "passengers"=>"75",
      "cost_in_credits"=>"240000",
      "cargo_capacity"=>"180000",
      "movies" => ['A New Hope']
    }
    @starship1_to_hash = {
      "name"=>"CR90 corvette",
      "passengers"=>"600",
      "cost_in_credits"=>"3500000",
      "cargo_capacity"=>"3000000",
      "movies" => ['A New Hope', 'Return of the Jedi', 'Revenge of the Sith']
    }
    @starship2_to_hash = {
      "name"=>"Star Destroyer",
      "passengers"=>"0",
      "cost_in_credits"=>"150000000",
      "cargo_capacity"=>"36000000",
      "moviese"=>["A New Hope", "The Empire Strikes Back", "Return of the Jedi"]
    }
  end

  describe 'starships' do
    describe '#get_passengers_info' do
      it 'show starship passengers info' do
        allow_any_instance_of(Analytics).to receive(:get_metric) do |instance|
          instance.instance_variable_set(:@data, @starship_result)
        end
        allow(@starship3).to receive(:to_hash).with('lowest', 'passengers').and_return(@starship3_to_hash)
        allow(@starship1).to receive(:to_hash).with('highest', 'passengers').and_return(@starship1_to_hash)

        result = Analytics.get_passengers_info('starship')

        expect(result).to eq({
          average: 225,
          min: 75,
          max: 600,
          total_count: 3,
          lowest: @starship3_to_hash,
          highest: @starship1_to_hash
        })
      end
    end

    describe '#cost_in_credits_info' do
      it 'show cost in credits info' do
        allow_any_instance_of(Analytics).to receive(:get_metric) do |instance|
          instance.instance_variable_set(:@data, @starship_result)
        end
        allow(@starship3).to receive(:to_hash).with('lowest', 'cost_in_credits').and_return(@starship3_to_hash)
        allow(@starship2).to receive(:to_hash).with('highest', 'cost_in_credits').and_return(@starship2_to_hash)

        result = Analytics.get_cost_in_credits_info('starship')

        expect(result).to eq({
          average: 51246666,
          min: 240000,
          max: 150000000,
          total_count: 3,
          lowest: @starship3_to_hash,
          highest: @starship2_to_hash
        })
      end
    end

    describe '#cargo_capacity' do
      it 'show cargo capacity info' do
        allow_any_instance_of(Analytics).to receive(:get_metric) do |instance|
          instance.instance_variable_set(:@data, @starship_result)
        end
        allow(@starship3).to receive(:to_hash).with('lowest', 'cargo_capacity').and_return(@starship3_to_hash)
        allow(@starship2).to receive(:to_hash).with('highest', 'cargo_capacity').and_return(@starship2_to_hash)

        result = Analytics.get_cargo_capacity_info('starship')

        expect(result).to eq({
          average: 13060000,
          min: 180000,
          max: 36000000,
          total_count: 3,
          lowest: @starship3_to_hash,
          highest: @starship2_to_hash
        })
      end
    end

    describe '#appeared_in_same_films_info' do
      it 'show starships appeared in the same film' do
        allow_any_instance_of(Analytics).to receive(:get_metric) do |instance|
          instance.instance_variable_set(:@data, @starship_result + @vehicle_result)
        end

        result = Analytics.appeared_in_same_films_info(2)

        expect(result).to eq(starships: ["Star Destroyer"], vehicles: ["Vehicle1"])
      end
    end
  end
end