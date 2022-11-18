library("dplyr")

account_data <- read.csv("data/account.csv", sep = ";")
card_data <- read.csv("data/card_dev.csv", sep = ";")
client_data <- read.csv("data/client.csv", sep = ";")
disp_data <- read.csv("data/disp.csv", sep = ";")
district_data <- read.csv("data/district.csv", sep = ";")
loan_data <- read.csv("data/loan_dev.csv", sep = ";")
trans_data <- read.csv("data/trans_dev.csv", sep = ";")

# Change empty string values to NA
account_data <-
  replace(account_data, (account_data == "" | account_data == " "), NA)
card_data <- replace(card_data, (card_data == "" | card_data == " "), NA)
client_data <-
  replace(client_data, (client_data == "" | client_data == " "), NA)
disp_data <-
  replace(disp_data, (disp_data == "" | disp_data == " "), NA)
district_data <-
  replace(district_data, (district_data == "" | district_data == " "), NA)
loan_data <- replace(loan_data, (loan_data == "" | loan_data == " "), NA)
trans_data <- replace(trans_data, (trans_data == "" | trans_data == " "), NA)

# Account data
# Make date more readable
account_data <- transform(account_data, date = format(as.Date(
  paste(
    paste("19", date %/% 10000, sep = ""),
    (date %/% 100) %% 100,
    date %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
), "%Y"))

colnames(account_data)[colnames(account_data) == "date"] <- "created"

# Card data
# Make date more readable
card_data <- transform(card_data, issued = format(as.Date(
  paste(
    paste("19", issued %/% 10000, sep = ""),
    (issued %/% 100) %% 100,
    issued %% 100,
    sep = "-"
  ),
  format = "%Y-%m-%d"
), "%Y"))


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

client_data$age <- trunc(as.numeric(
  difftime(Sys.Date(), client_data$birthday, units = "weeks")
) / 52.25)

client_data <- subset(client_data, select = -c(birth_number, birthday))

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
# Rename k_symbol column
colnames(trans_data)[colnames(trans_data) == "k_symbol"] <- "category"

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

trans_data$category[is.na(trans_data$category)] <- "other"

# Drop type column: withdrawal in cash already in operation, withdrawal
# vs credit already in amount sign

trans_data <- subset(trans_data, select = -c(type))

## Remove columns with more than 70% NA
account_data <- account_data %>% select(where(~ mean(is.na(.)) < 0.7))
card_data <- card_data %>% select(where(~ mean(is.na(.)) < 0.7))
client_data <- client_data %>% select(where(~ mean(is.na(.)) < 0.7))
district_data <- district_data %>% select(where(~ mean(is.na(.)) < 0.7))
disp_data <- disp_data %>% select(where(~ mean(is.na(.)) < 0.7))
loan_data <- loan_data %>% select(where(~ mean(is.na(.)) < 0.7))
trans_data <- trans_data %>% select(where(~ mean(is.na(.)) < 0.7))


# Aggregate transactions data
aggregated_trans <- trans_data %>%
  # Group by account
  group_by(account_id) %>%
  arrange(date, .by_group = TRUE) %>%
  # Add number of transactions per account
  mutate(trans_count = n()) %>%
  # Count credits/withdrawals
  mutate(credit_count = sum(amount >= 0)) %>%
  mutate(credit_ratio = mean(amount >= 0)) %>%
  mutate(withdrawal_count = sum(amount < 0)) %>%
  mutate(withdrawal_ratio = mean(amount < 0)) %>%
  # Amount stats
  mutate(amount_min = amount[which.min(abs(amount))][1]) %>%
  mutate(amount_max = amount[which.max(abs(amount))][1]) %>%
  mutate(amount_net = sum(amount)) %>%
  # Balance stats
  mutate(balance_min = min(balance)) %>%
  mutate(balance_max = max(balance)) %>%
  mutate(balance_mean = mean(balance)) %>%
  # Operation ratios
  mutate(credit_cash_ratio =
    mean(as.character(operation) == "credit in cash")) %>%
  mutate(collection_bank_ratio =
    mean(as.character(operation) == "collection from another bank")) %>%
  mutate(interest_ratio =
    mean(as.character(operation) == "interest credited")) %>%
  mutate(withdrawal_cash_ratio =
    mean(as.character(operation) == "withdrawal in cash")) %>%
  mutate(remittance_bank_ratio =
    mean(as.character(operation) == "remittance to another bank")) %>%
  mutate(withdrawal_card_ratio =
    mean(as.character(operation) == "credit card withdrawal")) %>%
  mutate(sanction_ratio =
    mean(as.character(category) == "sanction interest if negative balance")) %>%

  distinct()


trans_agg <- subset(aggregated_trans, select =
  -c(trans_id, operation, amount, balance, date, category)
)
