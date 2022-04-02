require 'rails_helper'

RSpec.describe Services::Operations do
  describe '.average' do
    it 'returns average result' do
      data = [1,2,3,4,5] 
      result = Services::Operations.average(data, data.size)

      expect(result).to eq 3
    end
  end

  describe '.min' do
    it 'returns min element' do
      data = [1,2,3,4,5] 
      result = Services::Operations.min(data)

      expect(result).to eq 1
    end
  end

  describe '.max' do
    it 'returns max element' do
      data = [1,2,3,4,5] 
      result = Services::Operations.max(data)

      expect(result).to eq 5
    end
  end

  describe '.lowest' do
    it 'returns lowest object' do
      data = [double(passengers: 10), double(passengers: 20), double(passengers: 30)]
      result = Services::Operations.lowest(data, :passengers)

      expect(result.passengers).to eq 10
    end
  end

  describe '.highest' do
    it 'returns highest object' do
      data = [double(passengers: 10), double(passengers: 20), double(passengers: 30)]
      result = Services::Operations.highest(data, :passengers)

      expect(result.passengers).to eq 30
    end
  end
end