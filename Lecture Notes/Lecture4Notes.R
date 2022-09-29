# (ignored by R and will NOT be read by R, but can be used to make comments to self)

require(tidyverse)

#assign a variable 

X <- 12 #preferred way to assign a variable 
Y = 6 
Z <- X + Y

#Naming variables 

k <- 16 #start with lowercase letter
koalaMass<- 45 #No spaces! Called "camelCase" (hump in the middle where each new word has a uppercase letter)
koala_mass <- 24 # "snake_case_format"
koala.mass <- 46 # permissable, but can cause confusion

# 1 dimensional -- Atomic vector -- list
# Character strings (words), integers, double, logical (true or false), factors, 

#Atomic
z <- c(4,5,7,22,14)
print(z)
typeof(z)
is.numeric(z)
z[4] #[] specifies the fourth position of the vector

#R will flatten atomic vectors

y <- c(c(4,6),c(45,23))

# input character strings with '' or ""
b <- c("earth","venus","mars")
print(b)

# logical vector, all caps
L <- c(TRUE,FALSE,TRUE)
typeof(L)
is.numeric(L)
is.logical(L)

# vector has 3 properties 
# type
typeof(z)
is.numeric(z)
# length
length(z)
# names
names(z)
names(z) <- c("mercury","venus","earth","mars","jupiter") # assign names to numbers
print(z)

z2 <- c(earth=4, mars=7) #assign names while making the vector
print(z2)
# get rid of names 
names(z2) <- NULL

# missing (NA) values for data
X <- c(3.2,3.3,NA)
typeof(X)
typeof(X[3]) # NA with other elements takes on the the type of the other elements

x2 <-NA
typeof(x2) #NA on its own is a "logical" 
is.na(X) # return a vector of logicals
mean(X) #the missing value returns an NA
na.omit(X)
#three ways to deal with missing values
mean(na.omit(X))
mean(X, na.rm =TRUE) # use the na.rm option if availible in the function
mean(X[!is.na(X)]) # yet another way to deal with NA variables

# Nan, -Inf, Inf from division
g <- 0/0
print(g)
i <- 1/0
print(i)

# NULL is an object that is nothing
n <- NULL
typeof(n)
length(n)
is.null(n)

# Coercion concept - rules of priority 
# logical < integer < double < character
# logical -> integer -> double -> character

a<- c(2,2.0)
print(a)
typeof(a)

b <- c(2,2)
print(b)
typeof(b)

c <- c("purple","green")
typeof(c)

d <- c(a,c)
typeof(d)
print(d)

# logicals get coerced into integers for useful calculations

a <- runif(10) #random uniform distribution (runif)
a > 0.2
sum(a > 0.2)
mean(a > 0.2)
mean(rnorm(1000) > 2) # random normal distribution (rnorm)

# Vectorization

Z <- c(10,20,30)
Z +1
y <- c(1,2,3)
Z + y

Z^2

# Operations will recycle vectors that are of different lengths (Warning)
X <- c(1,2)
Z + X 

# 2 dimensional -- Matrix -- Data Frame


# 3 dimensional -- Array 
