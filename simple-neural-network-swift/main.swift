//
//  main.swift
//  simple-neural-network-swift
//
//  Created by OrigamiDream on 2019-03-29.
//  Copyright © 2019 AEGIS. All rights reserved.
//

import Foundation

// XOR Gate


struct ResultData {

    var actualValue: Double
    var fixedValue: Int = 0
    var expectedValue: Int = 0
    var toString: String {
        get {
            return "\(actualValue) -> \(fixedValue) : Expected: \(expectedValue); Error: \(expectedValue != fixedValue)"
        }
    }

    init(actualValue: Double, expectedValue: Int) {
        self.actualValue = actualValue
        self.expectedValue = expectedValue
    }
}

func analyze(test: [Int: [Double]], _ network: Network) {
    for key in test.keys {
        network.think(Array(repeating: test[key]!, count: 1))

        let value = network.getOutput().getMatrix()[0][0]
        var result = ResultData(actualValue: value, expectedValue: key)
        if (value >= 0.5) {
            result.fixedValue = 1
        } else {
            result.fixedValue = 0
        }
        print(result.toString)
    }
}

let network = Network.builder().learningRate(0.1).iterations(100000).inputNeurons(2)
.addLayer(Layer.builder().neurons(4).function(Layer.FunctionType.SIGMOID))
.addLayer(Layer.builder().neurons(3).function(Layer.FunctionType.SIGMOID))
.addLayer(Layer.builder().neurons(1).function(Layer.FunctionType.SIGMOID))
.build()

let inputs: [[Double]] = [[0, 0], [0, 1], [1, 0], [1, 1]]
let outputs: [[Double]] = [[0], [1], [1], [0]]

network.train(inputs, outputs)

analyze(test: [0: [1.0, 1.0]], network)
analyze(test: [1: [1.0, 0.0]], network)
analyze(test: [1: [0.0, 1.0]], network)
analyze(test: [0: [0.0, 0.0]], network)
