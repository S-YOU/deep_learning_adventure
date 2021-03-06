require 'numo/narray'
require 'numo/gsl'
require "numo/linalg"
require 'csv'

def predict(x, w)
    Numo::Linalg.matmul(x, w)
end

def loss(x, y, w)
    Numo::GSL::Stats.mean((predict(x, w) - y) ** 2)
end

def gradient(x, y, w)
    2 * Numo::Linalg.matmul(x.transpose, (predict(x, w) - y)) / x.shape[0]
end

def train(x, y, iterations:, lr:)
    w = Numo::DFloat.zeros(X.shape[1], 1)
    iterations.times do |iteration|
        puts "#{iteration} => Loss: #{loss(x, y, w)}"
        w -= gradient(x, y, w) * lr
    end
    w
end

# Load data
data = CSV.read("more_pizza.txt", col_sep: "\s", headers: true)
X = Numo::NArray.column_stack([
      Numo::DFloat.ones(data.size),
      data['Reservations'].map(&:to_f),
      data['Temperature'].map(&:to_f),
      data['Tourists'].map(&:to_f)
    ])
Y = Numo::NArray[*data['Pizzas'].map(&:to_i)].reshape(data.size, 1)

w = train(X, Y, iterations: 50000, lr: 0.001)

puts "Weights: #{w.transpose}"
puts "A few predictions:"
predictions = predict(X, w)
0.upto(4) do |i|
    puts "Prediction: #{predictions[i].round()}; label: #{Y[i]}"
end
