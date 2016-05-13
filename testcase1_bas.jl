## Test Case 1

using JuMP
using Cbc

include("domain.jl")

zwitsalHuidolie = Product("Zwitsal Huidolie", 10)
zwitsalBodylotion = Product("Zwitsal Bodylotion", 8)
zwitsalShampoo = Product("Zwitsal Shampoo", 9)
andrelonShampoo = Product("Andrelon Shampoo", 6)
niveaShampoo = Product("Nivea Shampoo", 7)

fixedValuePromotion = Promotion(
  "Buy 4 Products get 8 euro discount", # name
  4, # numberOfProducts
  [zwitsalHuidolie, zwitsalShampoo, zwitsalBodylotion, niveaShampoo, andrelonShampoo], #applicableProducts
  8, # discountValue
  "FIXED_VALUE" # kind
)

zwitsalPromotion = Promotion(
  "Buy 3 Zwitsal products, get the cheapest one for free", #name
  3, # number of products required
  [zwitsalBodylotion, zwitsalShampoo, zwitsalHuidolie], # applicable products
  100, # discount value percentage
  "PERCENTAGE_VALUE_ON_CHEAPEST"
)

shampooPromotion = Promotion(
  "Buy 3 shampoo's, get the cheapest one for free", #name
  3, # number of prducts required
  [zwitsalShampoo, andrelonShampoo, niveaShampoo], # applicable products
  100, # discountValue percentage
  "PERCENTAGE_VALUE_ON_CHEAPEST"
)

promotions = [fixedValuePromotion, zwitsalPromotion, shampooPromotion]
fixedValuePromotions = [fixedValuePromotion]
percentageValuePromotions = [zwitsalPromotion, shampooPromotion]


#############################################################################

m = Model(solver = CbcSolver(seconds=10))

for promotion in promotions
  @variable(m, 0 <= assignment[promotion.applicableProducts, promotion], Bin)
end
