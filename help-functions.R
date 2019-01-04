import_matrix <- function(sheet_name, NA_value = NA, diagonal = "do_nothing") {
  mat <- as.matrix(read.xlsx("input-matrices.xlsx", sheet = sheet_name, rowNames = TRUE, colNames = TRUE))
  index_NA <- which(is.na(mat))
  mat[index_NA] <- NA_value
  
  if ("do_nothing" != diagonal) for (i in 1:nrow(mat)) mat[i, i] <- diagonal
  
  mat
}

total_number_of_routes <- function(n) {
  x <- 0
  for (k in 2:n) {
    x <- x + factorial(n) / factorial(n - k)
  }
  x
}

routes_length_n <- function(n){
  if (1 == n) {
    return(matrix(1))
  } else {
    sp <- routes_length_n(n - 1)
    p  <- nrow(sp)
    A  <- matrix(nrow = n * p, ncol = n)
    
    for (i in 1:n) {
      A[(i - 1) * p + 1:p,] <- cbind(i, sp + (i <= sp))
    }
    
    return(A)
  }
}

all_routes_matrix <- function(n) {
  routes_n <- routes_length_n(n) # all routes with length n

  routes <- NULL
  for (i in 2:n) {
    sub_routes <- unique(routes_n[, 1:i])
    NA_routes  <- matrix(NA, nrow = nrow(sub_routes), ncol = n - ncol(sub_routes))
    routes <- rbind(routes, cbind(sub_routes, NA_routes))
  }
  
  routes
}

describe_route <- function(country) {
  country_names <- colnames(A)[country]
  cat(paste0("Route: ", paste(country_names, collapse = " -> "), ".\n"))
  cat("\n")
  tax <- 0
  for (i in 2:length(country) - 1) {
    tax_i <- if (1 == i) A[country[i], country[1 + i]] else Q[country[i], country[1 + i]]
    tax <- 1 - (1 - tax) * (1 - tax_i)
    cat(paste0(i, ") ", if (1 == i) "A[" else "Q[", country_names[i], "(", country[i], ")", ", ", country_names[1 + i], "(", country[1 + i], ")", "] = ", tax_i, "   |   ", "Total tax = ", tax, "\n"))
    # cat(i, ")", paste0(if (1 == i) "A[" else "Q[", country_names[i], ", ", country_names[1 + i], "] = ", tax_i, "\n"))
    # cat(i, ")", paste0("Tax (now)   = ", tax, "\n\n"))
  }
  cat("\n")
  cat(paste0("S[", country_names[1], ", ", tail(country_names, 1), "] = ", S[country[1], tail(country, 1)], "\n"))
}

is_valid_route <- function(country) {
  tax <- 0
  for (i in 2:length(country) - 1) {
    tax_i <- if (1 == i) A[country[i], country[1 + i]] else Q[country[i], country[1 + i]]
    tax <- 1 - (1 - tax) * (1 - tax_i)
  }
  return(abs(tax - S[country[1], tail(country, 1)]) < eps)
}

#describe_route(a_route)
#which(S == min(S[S>3e-8]), arr.ind = TRUE)


















