# Error Propagation Calculator in R

This repository provides an R implementation of **sequential error propagation** for common mathematical operations. It allows users to perform chained calculations with uncertainties and automatically propagate the associated errors using standard propagation formulas.

---

## Features

- **Supported operations**:
  - Addition (`A`)
  - Subtraction (`S`)
  - Multiplication (`M`)
  - Division (`D`)
  - Natural logarithm (`L`, base *e*)
  - Natural antilogarithm (`N`, base *e*)

- **Automatic error propagation** based on first-order uncertainty propagation rules.
- **Sequential calculation** using a simple operation string.
- **Intermediate results printed** with their propagated uncertainties.

---

## How It Works

### Error Propagation Functions
Each mathematical operation has a corresponding function that takes input values and their uncertainties, then returns the result and its propagated error:

- `add_error(a, da, b, db)`
- `sub_error(a, da, b, db)`
- `mul_error(a, da, b, db)`
- `div_error(a, da, b, db)`
- `log_error(a, da)` – natural log by default
- `antilog_error(a, da)` – natural antilog by default

### Sequential Propagation
Use `propagate_operations(values, errors, steps)` to apply multiple operations in sequence:

- `values`: numeric vector of values.
- `errors`: numeric vector of their uncertainties.
- `steps`: string encoding the operations.  
  - `M` = multiply  
  - `D` = divide  
  - `A` = add  
  - `S` = subtract  
  - `L` = natural log  
  - `N` = natural antilog  

Example:  
```r
values <- c(18.3, 1.138345132, 0.369742364)
errors <- c(0, 0.04256035, 0.006428537)
steps <- "LSDN"  
# Take ln(value1), subtract value2, divide by value3, then exponentiate

result <- propagate_operations(values, errors, steps)
cat(sprintf("Final result: %g ± %g\n", result$final_value, result$final_error))
