---
title: "Evaluating CDFs using SymPy"
subtitle: "A look at Fire Emblems 'True Hit'"
author: 8bit-pixies
author-url: "https://github.com/8bit-pixies/"
toc-title: Contents
---

# 2023 October 20

SymPy is pretty useful for symbolic things. One of the items which I was surprised by, was the ability to interrogate and get "closed form" equations (at least to the most simplified symbolic representation) of "unusual" distributions which may not have CDF implementations naturally available. You can then use these representations to evaluate them. For example the [Irwin-Hall](https://en.wikipedia.org/wiki/Irwin%E2%80%93Hall_distribution) distribution can be addressed as follows:

```py
from sympy.stats import UniformSum, cdf
from sympy import Symbol

n = Symbol("n", integer=True)
uniform_sum = UniformSum("x", n)
x = Symbol("x")
cdf(uniform_sum)(x)
# Piecewise(
#   (0, x < 0),
#   (
#     Sum((-1)**_k*(-_k + x)**n*binomial(n, _k), (_k, 0, floor(x)))
#       / factorial(n), n >= x
#   ),
#   (1, True)
# )
```

We can evaluate a particular distribution as follows:

```py
cdf(UniformSum("x", 2), evaluate=True)(1.5).doit()
# 0.875
```

One _could_ print out the CDF and rewrite it in some kind of closed form solution, but having something handy like this is quite amazing as there doesn't appear to be many "common" packages that implement this kind of interface. 

You might be wondering how did I end up trying to calculate this? This actually comes from figuring out the "true hit" from the statistics displayed by Fire Emblem 6 in their combat calculation. In this formulation, the provided "probability" (out of 100) is actually based on taking the average of 2 random rolls of a 100 face die. To calculate this, we would do:

```py
hit_rate = 70
scaling_factor = 1/50  # 2/100
cdf(UniformSum("x", 2), evaluate=True)(hit_rate * scaling_factor).doit()
# 0.82

hit_rate = 40
cdf(UniformSum("x", 2), evaluate=True)(hit_rate * scaling_factor).doit()
# 0.32
```

You can see in the game it is more lenient towards higher accuracy numbers and punishes numbers under 50% much more