module Services
  module Operations
    extend self

    def average(data, size)
      data.reduce(:+) / size
    end

    def min(data)
      data.min
    end

    def max(data)
      data.max
    end

    def lowest(data, field)
      data.min_by { |metric| metric.public_send(field).to_i }
    end

    def highest(data, field)
      data.max_by { |metric| metric.public_send(field).to_i }
    end
  end
end