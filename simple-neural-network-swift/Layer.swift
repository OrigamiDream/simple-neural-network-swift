//
// Created by OrigamiDream on 2019-03-29.
// Copyright (c) 2019 AEGIS. All rights reserved.
//

import Foundation

class Layer {

    static func builder() -> Builder {
        return Builder()
    }

    class Builder {

        var functionType: FunctionType!
        var neurons: Int = 0

        func function(_ functionType: FunctionType) -> Self {
            self.functionType = functionType
            return self
        }

        func neurons(_ neurons: Int) -> Self {
            self.neurons = neurons + 1
            return self
        }

    }

    class FunctionType {

        static let SIGMOID = FunctionType({ x in 1.0 / (1.0 + exp(-x)) }, { x in x * (1 - x) })
        static let TANH = FunctionType({ x in tanh(x) }, { x in 1 - tanh(x) * tanh(x) })
        static let RELU = FunctionType({ x in (x > 0) ? x : 0.0 }, { x in (x > 0) ? 1.0 : 0.0 })

        let function: (Double) -> Double
        let derivative: (Double) -> Double

        init(_ function: @escaping (Double) -> Double, _ derivative: @escaping (Double) -> Double) {
            self.function = function
            self.derivative = derivative
        }

        func getFunction() -> (Double) -> Double {
            return function
        }

        func getDerivative() -> (Double) -> Double {
            return derivative
        }
    }

    var weights: Matrix
    let functionType: FunctionType
    let neurons: Int

    init(_ functionType: FunctionType, _ neuronNum: Int, _ inputNum: Int) {
        self.weights = Matrix(inputNum, neuronNum)
        self.functionType = functionType
        self.neurons = neuronNum

        for i in 0 ..< inputNum {
            for j in 0 ..< neuronNum {
                if i == inputNum - 1 {
                    // Bias neurons
                    weights.set(i, j, 1)
                } else {
                    weights.set(i, j, 0)
                }
            }
        }
    }

    func adjust(_ adjust: Matrix) {
        ThrowUtils.handleThrows {
            try self.internalAdjust(adjust)
        }
    }

    func internalAdjust(_ adjust: Matrix) throws {
        self.weights = try (self.weights + adjust)!
    }
}
