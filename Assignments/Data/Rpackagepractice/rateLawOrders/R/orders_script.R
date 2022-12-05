#' Add First Order and Second Order Columns
#'
#' Takes absorbance or concentration data for a reaction and finds the first order and second order values so that all possible order plots can be graphed later
#' @name all_orders
#' @param The dataset for which we are converting, containing a Time and Absorbance column
#' @return A new table with the following columns: Time, zero_order, first_order, second_order
#' @examples all_orders(dataset)

library("dplyr") #to allow us to use the 'mutate' and 'rename' functions

all_orders <- function(dataset) {
  mutate (dataset,
          first_order = log(Absorbance),
          second_order = 1/Absorbance
  ) %>%
    rename (zero_order = Absorbance)
}