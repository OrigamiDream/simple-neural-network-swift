//
// Created by OrigamiDream on 2019-03-29.
// Copyright (c) 2019 AEGIS. All rights reserved.
//

import Foundation

class ThrowUtils {

    static func handleThrows(_ runnable: @escaping () throws -> Void) {
        do {
            try runnable()
        } catch MatrixError.ON_PROPAGATE {
            print("Same matrixes required on propagation")
        } catch MatrixError.ON_SUBRACT {
            print("Same matrixes required on subtraction")
        } catch MatrixError.ON_ADD {
            print("Same matrixes required on addition")
        } catch MatrixError.ON_MULTIPLY {
            print("Same matrixes required on multiplication")
        } catch MatrixError.ON_APPLY {
            print("Same matrixes required on applying functions")
        } catch {
            print("Default throw")
        }
    }

}