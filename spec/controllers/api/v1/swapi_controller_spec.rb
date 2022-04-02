require 'rails_helper'

RSpec.describe Api::V1::SwapiController do
  describe "GET passengers" do
    it "returns result" do
      result = {
        "average"=>111111,
        "min"=>0,
        "max"=>843342,
        "total_count"=>36,
        "lowest"=>{"name"=>"Y-wing", "passengers"=>0, "cost_in_credits"=>134999, "cargo_capacity"=>110, "movies"=>["A New Hope", "The Empire Strikes Back", "Return of the Jedi"]},
        "highest"=>{"name"=>"Death Star", "passengers"=>843342, "cost_in_credits"=>1000000000000, "cargo_capacity"=>1000000000000, "movies"=>["A New Hope"]}
      }
      allow(Analytics).to receive(:get_passengers_info).with('starship').and_return(result)
      get :passengers, params: { metric: 'starship' }

      expect(response.code).to eq '200'
      expect(response.body).to eq result.to_json
    end

    it "throws error if param is not correct" do
      get :passengers, params: { wrong: 'starship' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end

    it "throws error if param value is not correct" do
      get :passengers, params: { metric: 'wrong' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end
  end

  describe "GET cost_in_credits" do
    it "returns result" do
      result = {
        "average"=>33333,
        "min"=>0,
        "max"=>843342,
        "total_count"=>36,
        "lowest"=>{"name"=>"Y-wing", "passengers"=>0, "cost_in_credits"=>134999, "cargo_capacity"=>110, "movies"=>["A New Hope", "The Empire Strikes Back", "Return of the Jedi"]},
        "highest"=>{"name"=>"Death Star", "passengers"=>843342, "cost_in_credits"=>1000000000000, "cargo_capacity"=>1000000000000, "movies"=>["A New Hope"]}
      }
      allow(Analytics).to receive(:get_cost_in_credits_info).with('starship').and_return(result)
      get :cost_in_credits, params: { metric: 'starship' }

      expect(response.code).to eq '200'
      expect(response.body).to eq result.to_json
    end

    it "throws error if param is not correct" do
      get :cost_in_credits, params: { wrong: 'starship' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end

    it "throws error if param value is not correct" do
      get :cost_in_credits, params: { metric: 'wrong' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end
  end

  describe "GET cargo_capacity" do
    it "returns result" do
      result = {
        "average"=>44444,
        "min"=>0,
        "max"=>843342,
        "total_count"=>36,
        "lowest"=>{"name"=>"Y-wing", "passengers"=>0, "cost_in_credits"=>134999, "cargo_capacity"=>110, "movies"=>["A New Hope", "The Empire Strikes Back", "Return of the Jedi"]},
        "highest"=>{"name"=>"Death Star", "passengers"=>843342, "cost_in_credits"=>1000000000000, "cargo_capacity"=>1000000000000, "movies"=>["A New Hope"]}
      }
      allow(Analytics).to receive(:get_cargo_capacity_info).with('starship').and_return(result)
      get :cargo_capacity, params: { metric: 'starship' }

      expect(response.code).to eq '200'
      expect(response.body).to eq result.to_json
    end

    it "throws error if param is not correct" do
      get :cargo_capacity, params: { wrong: 'starship' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end

    it "throws error if param value is not correct" do
      get :cargo_capacity, params: { metric: 'wrong' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end
  end

  describe "GET appeared_in_same_films" do
    it "returns result" do
      result = {
        "starships"=>["Star Destroyer", "Millennium Falcon", "Y-wing", "X-wing", "Executor", "Rebel transport", "Slave 1", "Imperial shuttle", "EF76 Nebulon-B escort frigate"],
        "vehicles"=>["TIE/LN starfighter", "Snowspeeder", "TIE bomber", "AT-AT", "AT-ST", "Storm IV Twin-Pod cloud car"]
      }
      allow(Analytics).to receive(:appeared_in_same_films_info).with('2').and_return(result)
      get :appeared_in_same_films, params: { film_number: 2 }

      expect(response.code).to eq '200'
      expect(response.body).to eq result.to_json
    end

    it "throws error if param is not correct" do
      get :cargo_capacity, params: { wrong: 'starship' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end

    it "throws error if param value is not correct" do
      get :cargo_capacity, params: { metric: 'wrong' }

      expect(response.code).to eq '400'
      expect(response.parsed_body).to eq({"error"=>"Metric param should be one of the following: [\"starship\", \"starships\", \"vehicle\", \"vehicles\"]"})
    end
  end
end