# jumping-julia
Xebia Innovation Day - May 13

## Requirements

- Julia (for mac, see https://github.com/staticfloat/homebrew-julia)
- Cbc Solver (I believe this will be automatically installed when you run `Pkg.add("Clp")` in the Julia console). Otherwise: see https://projects.coin-or.org/Cbc

See also http://jump.readthedocs.io/en/latest/

## Case 1 - Promotions

A webshop may provide discount to a customer's purchases by enabling promotions.

A promotion can be of the following form

- buy product *X* and get a fixed amount *Y* of discount
- buy product *X* and get a discount of percentage *Y*
- buy a number of products *Xs* and get a discount of percentage *Y* on the cheapest product
- ....

Constraints:

- each product can only be assigned to at most 1 promotion

Optimize:

Assign the products to a promotion such that the largest discount is achieved.

## Test Data Case 1 - Wehkamp says it's not solvable with Mixed Integer Programming

Products:

- "Zwitsal Huidolie" a 10 euro
- "Zwitsal Bodylotion" a 8 euro
- "Zwitsal Shampoo" a 9 euro
- "Andrelon Shamppo" a 6 euro
- "Niveau Shampoo" a 7 euro

Promotions:

- Buy 4 products, get a discount of 8 euro (fixed)
- Buy 3 Zwistal products, get the cheapest one for free
- Buy 3 shampoo's, get the cheapest one for free

