using JuMP
using Cbc

type Item
  brand::AbstractString
  product::AbstractString
  price::Int
end

type Promotion
  numberOfProducts::Int
  discount::Int
  brand::AbstractString
  product::AbstractString
end

println("Hello Julia")

m = Model(solver = CbcSolver(seconds=10))

basket = [
 Item("Zwitsal", "Huidolie", 10),
 Item("Zwitsal", "Bodylotion", 8),
 Item("Zwitsal", "Shampoo", 9),
 Item("Andrelon", "Shampoo", 6),
 Item("Nivea", "Shampoo", 7) ]

promotions = [ 
  Promotion(4, 7, "", "")
  Promotion(3, 1, "Zwitsal", "")
  Promotion(3, 8, "", "Shampoo")
]

@variable(m, 0 <= disc[basket, promotions] <= 1, Bin)
@variable(m, 0 <= chosen[promotions] <= 1, Bin)

# a chosen promotion selects the correct number of items
for promotion in promotions
  @constraint(m, sum{disc[i,promotion], i=basket} == promotion.numberOfProducts * chosen[promotion])
end

# an item only participates in one promotion
for item in basket
  @constraint(m, sum{disc[item,p], p=promotions} <= 1)
end

for promotion in promotions, item in basket
  if promotion.brand != "" && promotion.brand != item.brand
    @constraint(m, disc[item, promotion] == 0)
  end
  if promotion.product != "" && promotion.product != item.product
    @constraint(m, disc[item, promotion] == 0)
  end
end

@objective(m, Max, sum{p.discount * chosen[p], p=promotions})

print(m)

status = solve(m)

println("Objective value: ", getobjectivevalue(m))
# println("x = ", getvalue(x))
# println("y = ", getvalue(y))
vals = getvalue(chosen)
println("chosen promotion = ", vals)
println("disc = ", getvalue(disc))
