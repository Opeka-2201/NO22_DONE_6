using JuMP, Gurobi

# optim model in Gurobi
model = Model(Gurobi.Optimizer)

#variable 
@variable(model, p1 >= 0)
@variable(model, p2 >= 0)
@variable(model, p3 >= 0)
@variable(model, p4 >= 0)
@variable(model, p5)

#constraints    
@constraint(model, -40 * p2 + p5 == -40)
@constraint(model, 40 * p1 + -60*p3 + p5 == 60)
@constraint(model, 60 *  p2 + -20*p4 + p5 == 40)
@constraint(model, -80* p2 +20* p3 + p5 == -60)


#objective 
@objective(model, Min, p5) 

optimize!(model)
println("p1 : ", value(p1))
println("p2 : ", value(p2))
println("p3 : ", value(p3))
println("p4 : ", value(p4))
println("p5 : ", value(p5))