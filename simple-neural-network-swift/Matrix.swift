//
// Created by OrigamiDream on 2019-03-29.
// Copyright (c) 2019 AEGIS. All rights reserved.
//

import Foundation

enum MatrixError: Error {

    case ON_PROPAGATE
    case ON_SUBRACT
    case ON_ADD
    case ON_MULTIPLY
    case ON_APPLY

}

class Matrix {

    private var matrix: [[Double]]

    init(_ x: Int, _ y: Int) {
        self.matrix = Array(repeating: Array(repeating: 0.0, count: y), count: x)
    }

    init(_ matrix: [[Double]]) {
        self.matrix = matrix
    }

    func getMatrix() -> [[Double]] {
        return self.matrix
    }

    func xLength() -> Int {
        return self.matrix.count
    }

    func yLength(_ index: Int) -> Int {
        return self.matrix[index].count
    }

    func yLength() -> Int {
        return self.yLength(0)
    }

    func set(_ x: Int, _ y: Int, _ value: Double) {
        self.matrix[x][y] = value
    }

    func propagate(_ other: Matrix) throws -> Matrix! {
        if(xLength() == 0 || other.xLength() == 0 || yLength() != other.xLength()) {
            throw MatrixError.ON_PROPAGATE
        }

        let result = Matrix(xLength(), other.yLength())
        for i in 0 ..< xLength() {
            for j in 0 ..< other.yLength() {
                var value = 0.0
                for h in 0 ..< yLength() {
                    value += getMatrix()[i][h] * other.getMatrix()[h][j]
                }
                result.set(i, j, value)
            }
        }
        return result
    }

    static func -(_ left: Matrix, _ right: Matrix) throws -> Matrix! {
        if(left.xLength() == 0 || right.xLength() == 0 || left.xLength() != right.xLength() || left.yLength() != right.yLength()) {
            throw MatrixError.ON_SUBRACT
        }
        let result = Matrix(left.xLength(), left.yLength())
        for i in 0 ..< left.xLength() {
            for j in 0 ..< left.yLength() {
                result.set(i, j, left.getMatrix()[i][j] - right.getMatrix()[i][j])
            }
        }
        return result
    }

    static func +(_ left: Matrix, _ right: Matrix) throws -> Matrix! {
        if(left.xLength() == 0 || right.xLength() == 0 || left.xLength() != right.xLength() || left.yLength() != right.yLength()) {
            throw MatrixError.ON_ADD
        }
        let result = Matrix(left.xLength(), left.yLength())
        for i in 0 ..< left.xLength() {
            for j in 0 ..< left.yLength() {
                result.set(i, j, left.getMatrix()[i][j] + right.getMatrix()[i][j])
            }
        }
        return result
    }

    static func *(_ left: Matrix, _ right: Matrix) throws -> Matrix! {
        if(left.xLength() == 0 || right.xLength() == 0 || left.xLength() != right.xLength() || left.yLength() != right.yLength()) {
            throw MatrixError.ON_MULTIPLY
        }
        let result = Matrix(left.xLength(), left.yLength())
        for i in 0 ..< left.xLength() {
            for j in 0 ..< left.yLength() {
                result.set(i, j, left.getMatrix()[i][j] * right.getMatrix()[i][j])
            }
        }
        return result
    }

    func transpose() -> Matrix {
        let result = Matrix(yLength(), xLength())
        for i in 0 ..< xLength() {
            for j in 0 ..< yLength() {
                result.set(j, i, getMatrix()[i][j])
            }
        }
        return result
    }

    func apply(_ fn: (Double) -> Double) -> Matrix {
        let result = Matrix(xLength(), yLength())
        for i in 0 ..< xLength() {
            for j in 0 ..< yLength() {
                result.set(i, j, fn(getMatrix()[i][j]))
            }
        }
        return result
    }
}
