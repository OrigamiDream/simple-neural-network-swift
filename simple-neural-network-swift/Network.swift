//
// Created by OrigamiDream on 2019-03-29.
// Copyright (c) 2019 AEGIS. All rights reserved.
//

import Foundation

class Network {

    class Builder {

        var layers = [Layer.Builder]()
        var learningRate = 0.1
        var input = 0
        var iterations = 1000

        func addLayer(_ builder: Layer.Builder) -> Self {
            self.layers.append(builder)
            return self
        }

        func inputNeurons(_ inputNeurons: Int) -> Self {
            self.input = inputNeurons
            return self
        }

        func learningRate(_ learningRate: Double) -> Self {
            self.learningRate = learningRate
            return self
        }

        func iterations(_ iterations: Int) -> Self {
            self.iterations = iterations
            return self
        }

        func build() -> Network {
            return Network(self)
        }

    }

    static func builder() -> Builder {
        return Builder()
    }

    var layers: [Layer?]
    var oLayers: [Matrix?]
    let learningRate: Double
    let iterations: Int

    init(_ builder: Builder) {
        self.learningRate = builder.learningRate
        self.iterations = builder.iterations

        let len = builder.layers.count
        self.layers = Array(repeating: nil, count: len)
        self.oLayers = Array(repeating: nil, count: len)

        var prev: Layer! = nil
        for i in 0 ..< len {
            let layer = builder.layers[i]
            if i == 0 {
                self.layers[i] = Layer(layer.functionType, layer.neurons, builder.input)
            } else {
                self.layers[i] = Layer(layer.functionType, i == len - 1 ? layer.neurons - 1 : layer.neurons, prev.neurons)
            }
            prev = layers[i]
        }
    }

    func think(_ input: [[Double]]) {
        ThrowUtils.handleThrows {
            try self.think(Matrix(input))
        }
    }

    private func think(_ input: Matrix) throws {
        for i in 0 ..< layers.count {
            let layer = layers[i]!

            if i == 0 {
                oLayers[i] = try input.propagate(layer.weights).apply(layer.functionType.getFunction())
            } else {
                oLayers[i] = try oLayers[i - 1]?.propagate(layer.weights).apply(layer.functionType.getFunction())
            }
        }
    }

    func train(_ input: [[Double]], _ output: [[Double]]) {
        train(Matrix(input), Matrix(output))
    }

    func train(_ input: Matrix, _ output: [[Double]]) {
        train(input, Matrix(output))
    }

    func train(_ input: [[Double]], _ output: Matrix) {
        train(Matrix(input), output)
    }

    private func train(_ input: Matrix, _ output: Matrix) {
        ThrowUtils.handleThrows {
            try self.internalTrain(input, output)
        }
    }

    private func internalTrain(_ input: Matrix, _ output: Matrix) throws {
        for iteration in 0 ..< iterations {
            try think(input)

            var prev: Matrix! = nil
            var deltas: [Matrix?] = Array(repeating: nil, count: oLayers.count)
            for i in (0 ..< oLayers.count).reversed() {
                let layer = oLayers[i]!
                var delta: Matrix
                if i == oLayers.count - 1 {
                    delta = try ((output - layer)! * (layer.apply(layers[i]!.functionType.getDerivative())))!
                } else {
                    assert(prev != nil)
                    delta = try ((prev.propagate(layers[i + 1]!.weights.transpose())) * (layer.apply(layers[i]!.functionType.getDerivative())))!
                }
                deltas[i] = delta
                prev = delta
            }

            for i in 0 ..< deltas.count {
                var adjustment: Matrix
                if i == 0 {
                    adjustment = try input.transpose().propagate(deltas[i]!)
                } else {
                    adjustment = try oLayers[i - 1]!.transpose().propagate(deltas[i]!)
                }
                adjustment = adjustment.apply { x in learningRate * x }

                layers[i]!.adjust(adjustment)
            }

            if iteration % 5000 == 0 {
                print("Training epoch \(iteration) of \(iterations)")
            }
        }
    }

    func getOutput() -> Matrix {
        return oLayers[oLayers.count - 1]!
    }

}
