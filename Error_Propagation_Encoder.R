# --- Clear Workspace ---
rm(list = ls())
if (!is.null(dev.list())) dev.off()

# --- Error propagation functions ---
{
# Addition: z = a + b
add_error <- function(a, da, b, db) {
  z <- a + b
  dz <- sqrt(da^2 + db^2)
  list(value = z, error = dz)
}

# Subtraction: z = a - b
sub_error <- function(a, da, b, db) {
  z <- a - b
  dz <- sqrt(da^2 + db^2)
  list(value = z, error = dz)
}

# Multiplication: z = a * b
mul_error <- function(a, da, b, db) {
  z <- a * b
  dz <- sqrt((da/a)^2 + (db/b)^2)*z
  list(value = z, error = dz)
}

# Division: z = a / b
div_error <- function(a, da, b, db) {
  z <- a / b
  dz <- sqrt((da/a)^2 + (db/b)^2)*z
  list(value = z, error = dz)
}

# Logarithm (baseQ): z = logQ(a)
log_error <- function(a, da) {
  Q = exp(1)
  z <- log(a,base=Q)
  dz <- (1/log(Q))*(da/a)
  list(value = z, error = dz)
}

# Antilogarithm (base Q): z = Q^a
antilog_error <- function(a, da) {
  Q = exp(1)
  z <- Q^a
  dz <- z * log(Q) * da
  list(value = z, error = dz)
}
}
# --- Main function: propagate operations sequentially ---
propagate_operations <- function(values, errors, steps) {
  if (nchar(steps) != (length(values) - 1) && !grepl("L|N", steps)) {
    stop("Length of steps must be one less than number of values, unless step involves unary ops (L,N).")
  }
  
  # Start with first value and error
  current_val <- values[1]
  current_err <- errors[1]
  val_index <- 2
  
  for (op in strsplit(steps, "")[[1]]) {
    if (op %in% c("A", "S", "M", "D")) {
      # Binary operations, need next value and error
      if (val_index > length(values)) {
        stop("Not enough values provided for binary operation")
      }
      next_val <- values[val_index]
      next_err <- errors[val_index]
      
      result <- switch(op,
                       A = add_error(current_val, current_err, next_val, next_err),
                       S = sub_error(current_val, current_err, next_val, next_err),
                       M = mul_error(current_val, current_err, next_val, next_err),
                       D = div_error(current_val, current_err, next_val, next_err),
                       stop(paste("Unsupported binary op:", op))
      )
      
      val_index <- val_index + 1
      
    } else if (op %in% c("L", "N")) {
      # Unary operations on current_val only
      result <- switch(op,
                       L = log_error(current_val, current_err),
                       N = antilog_error(current_val, current_err),
                       stop(paste("Unsupported unary op:", op))
      )
      
    } else {
      stop(paste("Unknown operation code:", op))
    }
    
    current_val <- result$value
    current_err <- result$error
    
    cat(sprintf("After operation %s: Value = %g ± %g\n", op, current_val, current_err))
  }
  
  list(final_value = current_val, final_error = current_err)
}

#Log and Antilog are Set to e^x and ln(x) by default. To change the base, the functions need to be edited.
#Programming for steps:
# M = Multiply, D = Divide, A = Add, S = Subtract, N = Antilog, L = Log

# --- Example usage ---
values <- c(18.3, 1.138345132, 0.369742364)
errors <- c(0, 0.04256035, 0.006428537)
steps <- "LSDN"  # Take the natrual log of the first number, subtract the second from that value, divide the result by the third value, and finlally exponentiate the result.

result <- propagate_operations(values, errors, steps)

cat(sprintf("Final result: %g ± %g\n", result$final_value, result$final_error))
