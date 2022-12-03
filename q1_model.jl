using JuMP, Gurobi

# A, B, C, D candidates
# 100 voters
# 4 candidates

# A beats B 30 times and loses 70 times : A_12 = 30 - 70 = -40
# B beats A 70 times and loses 30 times : B_12 = 70 - 30 = 40
# B beats C 20 times and loses 80 times : B_23 = 20 - 80 = -60
# B beats D 90 times and loses 10 times : B_34 = 90 - 10 = 80
# C beats B 80 times and loses 20 times : C_23 = 80 - 20 = 60
# C beats D 40 times and loses 60 times : C_34 = 40 - 60 = -20
# D beats B 10 times and loses 90 times : D_34 = 10 - 90 = -80
# D beats C 60 times and loses 40 times : D_34 = 60 - 40 = 20

A = [0 -40 0 0;
    40 0 -60 80;
    0 60 0 -20;
    0 -80 20 0]

e = ones(4)

# Maximize on polyhedron {p in R^n | p >= 0, p^T e= 1, p^T a = 0}

# Implement model in Gurobi

m = Model(Gurobi.Optimizer)

@variable(m, p[1:4] .>= 0)

@constraint(m, p' * e  == 1)

@constraint(m, p' * A .>= 0)

@objective(m, Min, p' * A * e)

optimize!(m)

println("p = ", value.(p))