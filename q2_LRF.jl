using JuMP, Gurobi

n = 2
candidates = 4
voters = 100

E = 0 
for i in 0:n
    global E += 12^i
end

elec = zeros((E+1)*candidates,candidates)

A = [ 0 -40   0   0;
     40   0 -60  80;
      0  60   0 -20;
      0 -80  20   0]

chang = [[0 2 0 0;-2 0 0 0;0 0 0 0;0 0 0 0],
         [0 0 2 0;0 0 0 0;-2 0 0 0;0 0 0 0],
         [0 0 0 2; 0 0 0 0;0 0 0 0;-2 0 0 0],
         [0 0 0 0;0 0 0 2;0 0 0 0;0 -2 0 0],
         [0 0 0 0;0 0 2 0;0 -2 0 0;0 0 0 0],
         [0 0 0 0;0 0 0 0;0 0 0 2;0 0 -2 0],
         [0 -2 0 0;2 0 0 0;0 0 0 0;0 0 0 0],
         [0 0 -2 0;0 0 0 0;2 0 0 0;0 0 0 0],
         [0 0 0 -2; 0 0 0 0;0 0 0 0;2 0 0 0],
         [0 0 0 0;0 0 -2 0;0 2 0 0;0 0 0 0],
         [0 0 0 0;0 0 0 -2;0 0 0 0;0 2 0 0],
         [0 0 0 0;0 0 0 0;0 0 0 -2;0 0 2 0]]

function get_change(chang , i)
    temp = zeros(4,4)
    while i > 0
        if i%12 != 0
            temp += chang[i%12]
        else
            temp += chang[12]
            i -= 12
        end
        i = i ÷ 12
        
    end
    return temp
end

elec[1:4,:] = A

for i in 1:E-1
    elec[4*(i)+1:4*(i)+4,:] = A + get_change(chang,i)
end

e = ones(4)

# Maximize on polyhedron {p in R^n | p >= 0, p^T e= 1, p^T a = 0}

# Implement model in Gurobi

m = Model(Gurobi.Optimizer)

@variable(m, p[1:4] .>= 0)

@constraint(m, c1, p' * e  == 1)

@objective(m, Max ,sum(elec * p))

@time begin
    optimize!(m)
end

println(value.(p))
println(solution_summary(m, verbose=true))