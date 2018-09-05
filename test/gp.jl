module TestGP
using GaussianProcesses, ScikitLearnBase
using Test, Random

Random.seed!(1)

@testset "GP" begin
    d, n = 3, 10

    X = 2π * rand(d, n)
    y = [sum(sin, view(X, :, i)) / d for i in 1:n]
    mZero = MeanZero()
    kern = SE(0.0, 0.0)

    gp = GP(X, y, mZero, kern)

    # Verify that predictive mean at input observations
    # are the same as the output observations
    @testset "Predictive mean" begin
        y_pred, sig = predict_y(gp, X)
        @test maximum(abs, gp.y - y_pred) ≈ 0.0 atol=0.1
    end

    # ScikitLearn interface test
    @testset "ScikitLearn interface" begin
        gp_sk = ScikitLearnBase.fit!(GPE(), X', y)
        y_pred = ScikitLearnBase.predict(gp_sk, X')
        @test maximum(abs, gp_sk.y - y_pred) ≈ 0.0 atol=0.1
    end

    # Modify kernel and update
    @testset "Update" begin
        gp.kernel.ℓ2 = 4.0
        X_pred = 2π * rand(d, n)

        GaussianProcesses.update_target!(gp)
        y_pred, sig = predict_y(gp, X_pred)
    end
end
end
