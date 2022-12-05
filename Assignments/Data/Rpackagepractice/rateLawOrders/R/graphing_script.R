#' Create Zero Order, First Order, and Second Order Plots
#'
#' Uses the dataset to create plots for each rate law order. Useful for checking to see which plot is most linear in order to determine the order of the reaction with respect to that reactant.
#' @name plot_orders
#' @param The dataset for which we are converting, which should already have columns added for the first order and second order data. The expected column labels are Time, zero_order, first_order, and second_order. 
#' @return Three plots, one for a zero order reaction, one for first order, and one for second order.
#' @examples plot_orders(dataset)

library("ggplot2")
library("patchwork")

plot_orders <- function(dataset) {
  
  zero_plot <- ggplot(data=dataset, aes(x=Time, y=zero_order, group=1)) +
    geom_line()+
    geom_point()
  
  first_plot <- ggplot(data=dataset, aes(x=Time, y=first_order, group=1)) +
    geom_line()+
    geom_point()
  
  second_plot <- ggplot(data=dataset, aes(x=Time, y=second_order, group=1)) +
    geom_line()+
    geom_point()
  
  all_plots <- (zero_plot + first_plot) / second_plot
  all_plots
}