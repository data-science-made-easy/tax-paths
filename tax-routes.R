rm(list = ls(all = T))
library(openxlsx)
source("help-functions.R")

A   <- import_matrix("MatrixA", NA_value = 0, diagonal = 0)
Q   <- import_matrix("MatrixQ", NA_value = 0, diagonal = 0)
S   <- import_matrix("S", NA_value = 0, diagonal = 0)
w   <- import_matrix("weightflows", NA_value = 0) # only w[i,i] == NA
A.  <- 1 - A
Q.  <- 1 - Q
S.  <- 1 - S

eps           <- 10^-6
all_countries <- 1:nrow(w)
country_names <- colnames(A)

is_shortest <- function(from, next_country, next_next_country = NA, to, fraction_payed, max_tax) {
  current_country <- tail(from, 1)
  
  if (to == next_country) {
    # Next is destination
    if (1 == length(from)) { # from is origin
      # DIRECT CONNECTION SOURCE - DESTINATION
      return(abs(max_tax - A[from, to]) < eps)
    } else { # from is not origin
      # END OF LONGER ROUTE
      fraction_payed <- 1 - (1 - fraction_payed) * Q.[current_country, to]
      return(abs(max_tax - fraction_payed) < eps)
    }    
  } else {
    if (to == next_next_country) {
      if (1 == length(from)) { # from is origin
        fraction_payed <- 1 - A.[current_country, next_country] * Q.[next_country, next_next_country]
        return(abs(max_tax - fraction_payed) < eps)
      } else { # from is not origin
        fraction_payed <- 1 - (1 - fraction_payed) * Q.[current_country, next_country] * Q[next_country, to]
        return(abs(max_tax - fraction_payed) < eps)
      }
    } else { # to is further than next_next_country
      if (1 == length(from)) {
        fraction_payed <- 1 - A.[current_country, next_country] * S.[next_country, to]
      } else {
        fraction_payed <- 1 - (1 - fraction_payed) * Q.[current_country, next_country] * S.[next_country, to]
      }
      return(abs(max_tax - fraction_payed) < eps)
    }
  }
}

routes <- function(from, to, fraction_payed = 0, max_tax = S[from, to]) {
  current_country <- tail(from, 1)
  
  if (to == current_country) {
    global_route_lst <<- append(global_route_lst, list(from))
    return(list(from))
  }
  
  new_routes <- list()
  for (next_country in all_countries[-from]) {
    shortest_exists <- FALSE
    for (next_next_country in all_countries[-c(from, next_country)]) {
      shortest_exists <- shortest_exists | is_shortest(from = from, next_country = next_country, next_next_country = next_next_country, to = to, fraction_payed = fraction_payed, max_tax = max_tax)
    }
    if (shortest_exists) {
      if (1 == length(from)) {
        fraction_payed_next <- A[from, next_country]
      } else {
        if (2 == length(from)) print(paste("Testing", from))
        fraction_payed_next <- 1 - (1 - fraction_payed) * Q.[current_country, next_country]
      }

      new_routes <- append(new_routes, routes(from = c(from, next_country), to = to, fraction_payed = fraction_payed_next, max_tax = max_tax))      
    }
  }
  
  return(new_routes)
}


global_route_lst = list()
all_possible_routes <- routes(1, 2)

max_route_length <- max(unlist(lapply(global_route_lst, length)))
mat <- matrix(NA, nrow = length(global_route_lst), ncol = max_route_length)
for (i in 1:length(global_route_lst))
  mat[i, 1:length(global_route_lst[[i]])] <- global_route_lst[[i]]

# write.xlsx(mat, "first_shortest_1_2.xlsx", colNames = FALSE)
describe_route(global_route_lst[[1]])










