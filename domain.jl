type Product
  name::AbstractString
  price::Int
end

type Promotion
  name::AbstractString
  numberOfProducts::Int
  applicableProducts::Array{Product,1}
  discountValue::Int
  kind::AbstractString
end

type DiscountProblem
  products::Array{Product, 1}
  promotions::Array{Promotion, 1}
end


