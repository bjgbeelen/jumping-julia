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
# @variable(m, 0 <= x <= 2 )
# @variable(m, 0 <= y <= 30 )
# @variable(m, xy)
# @constraint(m, xy == x * y)
# @variable(m, 0 <= promotion <= 3, Int)
# @variable(m, b, Bin)
# @variable(m, amount)

# @constraint(m, 1x + 5y <= 3.0 )
# @constraint(m, b == true)
# @constraint(m, ((promotion == 2) * 8) == amount)

basket = [
 Item("Zwitsal", "Huidolie", 10),
 Item("Zwitsal", "Bodylotion", 8),
 Item("Zwitsal", "Shampoo", 9),
 Item("Andrelon", "Shampoo", 6),
 Item("Nivea", "Shampoo", 7) ]

promotions = [ 
  Promotion(4, 7, "", "")
  Promotion(3, 0, "Zwitsal", "")
  Promotion(3, 0, "", "Shampoo")
]

@variable(m, 0 <= disc[basket, promotions] <= 1, Bin)
@variable(m, 0 <= chosen[promotions] <= 1)

# To prevent searching for chosen in binary
for item in basket
  for promotion in promotions
    @constraint(m, disc[item,promotion] <= chosen[promotion])
  end
end

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

@variable(m, 0 <= cheapest[basket, promotions] <= 1, Bin)
for promotion in promotions
  if promotion.discount == 0
    # there is only one item the cheapest (if the promotion is chosen)
    @constraint(m, sum{cheapest[item, promotion], item=basket} == 1 * chosen[promotion])

    # value of the cheapest selection item = sum{n.price * cheapest[n, promotion], n=basket}
    #for item in basket
      # if selected, the cheapest should be cheaper:
    #  @constraint(m, item.price >= sum{n.price * cheapest[n, promotion] * disc[item, promotion], n=basket})
    #end
  end
end

@variable(m, 0 <= valueof[promotions] <= 1000)

for promotion in promotions
  if promotion.discount == 0
    @constraint(m, valueof[promotion] == sum{item.price * cheapest[item, promotion], item=basket})
  end
  if promotion.discount != 0
    @constraint(m, valueof[promotion] == chosen[promotion] * promotion.discount)
  end
end

@objective(m, Max, sum{valueof[p], p=promotions})

print(m)

status = solve(m)

#function getvalue(p::Promotion)
#  promotion.discount
#end

println("Objective value: ", getobjectivevalue(m))
# println("x = ", getvalue(x))
# println("y = ", getvalue(y))
vals = getvalue(chosen)
println("chosen promotion = ", vals)
println("disc = ", getvalue(disc))
