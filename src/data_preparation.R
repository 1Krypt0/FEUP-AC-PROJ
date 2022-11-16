library("dplyr")

account_data <- read.csv("data/account.csv", sep = ";")
card_data <- read.csv("data/card_dev.csv", sep = ";")
client_data <- read.csv("data/client.csv", sep = ";")
disp_data <- read.csv("data/disp.csv", sep = ";")
district_data <- read.csv("data/district.csv", sep = ";")
loan_data <- read.csv("data/loan_dev.csv", sep = ";")
trans_data <- read.csv("data/trans_dev.csv", sep = ";")

# Account data
# Make date more readable
account_data <- transform(account_data, date = as.Date(
  paste(
    paste("19", date %/% 10000, sep = ""),
    (date %/% 100) %% 100,
    date %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
))

# Client data
# Separate gender and birthday from birth_number and drop birth_number
client_data <- transform(client_data,
  gender = ifelse(((birth_number %/% 100) %% 100) <= 12, "Male", "Female")
)

client_data <- transform(client_data, birthday = as.Date(
  paste(
    paste("19", birth_number %/% 10000, sep = ""),
    ifelse(((birth_number %/% 100) %% 100) <= 12,
      (birth_number %/% 100) %% 100,
      ((birth_number %/% 100) %% 100) - 50
    ),
    birth_number %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
))

client_data <- subset(client_data, select = -c(birth_number))

# Loan data
# Make date more readable
loan_data <- transform(loan_data, date = as.Date(
  paste(
    paste("19", date %/% 10000, sep = ""),
    (date %/% 100) %% 100,
    date %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
))

# Transaction data
# Make date more readable
trans_data <- transform(trans_data, date = as.Date(
  paste(
    paste("19", date %/% 10000, sep = ""),
    (date %/% 100) %% 100,
    date %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
))


# Make amount reflect if money entered or left the account
trans_data <- transform(trans_data,
  amount = ifelse(type == "credit", amount, -1 * amount)
)

# Every entry where the operation is null, the k_symbol is defined as
# "interest credited", so we can fill operation column with new type
# - interest credited

trans_data <- transform(trans_data,
  operation = ifelse(
    is.na(trans_data$operation) | trans_data$operation == "" |
      trans_data$operation == " ",
    "interest credited",
    operation
  )
)
