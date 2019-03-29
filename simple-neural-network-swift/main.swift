//
//  main.swift
//  simple-neural-network-swift
//
//  Created by OrigamiDream on 2019-03-29.
//  Copyright © 2019 AEGIS. All rights reserved.
//

import Foundation

// XOR Gate

func analyze(test: [[Double]], _ network: Network) {
    network.think(test)

    let array = network.getOutput().getMatrix()[0]
    var result: [Int] = Array(repeating: 0, count: array.count)
    for i in 0 ..< array.count {
        let value = array[i]
        if value >= 0.5 {
            result[i] = 1
        } else {
            result[i] = 0
        }
        print(value)
    }

    print(result)
}

let network = Network.builder().learningRate(0.1).iterations(100000).inputNeurons(2)
.addLayer(Layer.builder().neurons(4).function(Layer.FunctionType.SIGMOID))
.addLayer(Layer.builder().neurons(3).function(Layer.FunctionType.SIGMOID))
.addLayer(Layer.builder().neurons(1).function(Layer.FunctionType.SIGMOID))
.build()

let inputs: [[Double]] = [[0, 0], [0, 1], [1, 0], [1, 1]]
let outputs: [[Double]] = [[0], [1], [1], [0]]

network.train(inputs, outputs)

analyze(test: [[1.0, 1.0]], network)
analyze(test: [[1.0, 0.0]], network)
analyze(test: [[0.0, 1.0]], network)
analyze(test: [[0.0, 0.0]], network)
