library("dplyr")

prepare_datasets <- function(train = TRUE) {
  account_data <- prepare_account()
  client_data <- prepare_client()
  disp_data <- prepare_disp()
  district_data <- prepare_district()
  card_data <- prepare_card(train)
  loan_data <- prepare_loan(train)
  trans_data <- prepare_trans(train)

  trans_data <- remove_empty_cols(trans_data)
  trans_data <- aggregate_trans_data(trans_data)

  data <- join_tables(account_data, card_data, client_data,
                        disp_data, district_data, loan_data,
                        trans_data)

  if (!train) data <- data %>% mutate(status = c(NA))
  write.csv(data, ifelse(train, "data/train.csv", "data/test.csv"))
}

prepare_account <- function() {
  # Load dataset
  account_data <- read.csv("data/account.csv", sep = ";")
  account_data <-
    replace(account_data, (account_data == "" | account_data == " "), NA)

  # Make date more readable
  account_data <- transform(account_data, acc_creation_date = as.Date(
    paste(
      paste("19", date %/% 10000, sep = ""),
      (date %/% 100) %% 100,
      date %% 100,
      sep = "-"
    ),
    format = "%Y-%m-%d"
  ))

  # Calculate age of account in days
  account_data$age_days <- trunc(as.numeric(
    difftime(Sys.Date(), account_data$acc_creation_date, units = "days")
  ))

  return(account_data)
}

prepare_client <- function() {
  # Load dataset
  client_data <- read.csv("data/client.csv", sep = ";")
  client_data <-
  replace(client_data, (client_data == "" | client_data == " "), NA)

  client_data <- transform(client_data,
    gender = ifelse(((birth_number %/% 100) %% 100) <= 12, "M", "F")
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

  client_data <- subset(client_data, select = -c(birth_number, district_id))

  return(client_data)
}

prepare_disp <- function() {
  # Load dataset
  disp_data <- read.csv("data/disp.csv", sep = ";")
  disp_data <-
    replace(disp_data, (disp_data == "" | disp_data == " "), NA)
}

prepare_district <- function() {
  # Load dataset
  district_data <- read.csv("data/district.csv",
    sep = ";", na.strings = c("NaN", "?"))
  district_data <-
    replace(district_data, (district_data == "" | district_data == " "), NA)

  # Rename code to district id to ease joins
  # Rename columns for consistency
  colnames(district_data)[colnames(district_data) == "code"] <- "district_id"
  colnames(district_data)[
    colnames(district_data) == "average.salary"
  ] <- "average_salary"
  colnames(district_data)[
    colnames(district_data) == "no..of.enterpreneurs.per.1000.inhabitants"
  ] <- "entrepreneur_rate"
  colnames(district_data)[
    colnames(district_data) == "no..of.inhabitants"
  ] <- "population"
  colnames(district_data)[
    colnames(district_data) == "ratio.of.urban.inhabitants"
  ] <- "urban_ratio"

  # Fix values that were "?" to be the column average
  district_data$unemploymant.rate..95[
    is.na(district_data$unemploymant.rate..95)
  ]  <- mean(as.numeric(district_data$unemploymant.rate..95), na.rm = TRUE)
  district_data$unemploymant.rate..96[
    is.na(district_data$unemploymant.rate..96)
  ] <- mean(as.numeric(district_data$unemploymant.rate..96), na.rm = TRUE)

  district_data$no..of.commited.crimes..95[
    is.na(district_data$no..of.commited.crimes..95)
  ] <- mean(as.numeric(district_data$no..of.commited.crimes..95), na.rm = TRUE)
  district_data$no..of.commited.crimes..96[
    is.na(district_data$no..of.commited.crimes..96)
  ] <- mean(as.numeric(district_data$no..of.commited.crimes..96), na.rm = TRUE)

  # Calculate average between 95 and 96
  district_data <- transform(district_data, unemployment_rate_avg =
    as.numeric(district_data$unemploymant.rate..95)
    + as.numeric(district_data$unemploymant.rate..96) / 2
  )
  district_data <- transform(district_data, crimes_rate_per_thousand =
    (as.numeric(district_data$unemploymant.rate..95)
    + as.numeric(district_data$unemploymant.rate..96) / 2)
    / as.numeric(district_data$population)
    * 1000
  )

  # Calculate whether or not the unemployment/crimes has been growing
  district_data <- transform(district_data, unemployment_growing =
    ifelse(
      as.numeric(district_data$unemploymant.rate..96) >
      as.numeric(district_data$unemploymant.rate..95),
      1,
      0
    )
  )
  district_data <- transform(district_data, crimes_growing =
    ifelse(
      as.numeric(district_data$no..of.commited.crimes..96) >
      as.numeric(district_data$no..of.commited.crimes..95),
      1,
      0
    )
  )


  district_data <- subset(district_data, select = -c(unemploymant.rate..95,
    unemploymant.rate..96, no..of.commited.crimes..95, no..of.commited.crimes..96,
    no..of.municipalities.with.inhabitants...499,
    no..of.municipalities.with.inhabitants.500.1999,
    no..of.municipalities.with.inhabitants.2000.9999,
    no..of.municipalities.with.inhabitants..10000,
    region,
    no..of.cities
  ))
  return(district_data)
}

prepare_card <- function(train = TRUE) {
  card_data <- read.csv(if_else(train,
    "data/card_dev.csv", "data/card_comp.csv"),
  sep = ";")
  card_data <- replace(card_data, (card_data == "" | card_data == " "), NA)
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
  return(card_data)
}

prepare_loan <- function(train = TRUE) {
  loan_data <- read.csv(ifelse(train,
    "data/loan_dev.csv", "data/loan_comp.csv"),
    sep = ";"
  )
  loan_data <- replace(loan_data, (loan_data == "" | loan_data == " "), NA)
  loan_data <- transform(loan_data, date = as.Date(
    paste(
      paste("19", date %/% 10000, sep = ""),
      (date %/% 100) %% 100,
      date %% 100,
      sep = "-"
    ),
    format = "%Y-%m-%d"
  ))
  return(loan_data)
}

prepare_trans <- function(train = TRUE) {
  trans_data <- read.csv(ifelse(train,
    "data/trans_dev.csv", "data/trans_comp.csv"),
    sep = ";"
  )
  trans_data <- replace(trans_data, (trans_data == "" | trans_data == " "), NA)
  # Rename k_symbol column
  colnames(trans_data)[colnames(trans_data) == "k_symbol"] <- "category"
  trans_data$account <- replace(
    trans_data$account,
    (trans_data$account == 0), NA
  )

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

  return(trans_data)
}

remove_empty_cols <- function(data) {
  result <- data %>% select(where(~ mean(is.na(.)) < 0.7))
  return(result)
}

aggregate_trans_data <- function(trans_data) {
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
    mutate(smallest_transaction = amount[which.min(abs(amount))][1]) %>%
    mutate(biggest_transaction = amount[which.max(abs(amount))][1]) %>%
    mutate(transactions_net = sum(amount)) %>%
    # Balance stats
    mutate(balance_min = min(balance)) %>%
    mutate(balance_max = max(balance)) %>%
    mutate(current_balance = last(balance)) %>%
    mutate(times_negative_balance = sum(balance < 0)) %>%
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
    mutate(sanctions =
      sum(as.character(category) == "sanction interest if negative balance")) %>%
    rename(trans_date = date) %>%

    distinct()

  trans_agg <- subset(aggregated_trans, select =
    -c(trans_id, operation, amount, balance, category)
  )

  return(trans_agg)
}

join_tables <- function(account_data, card_data, client_data,
                        disp_data, district_data, loan_data,
                        trans_data) {

  last_transaction <- max(trans_data$trans_date)
  trans_data <- trans_data %>%
    select(-trans_date)

  # Join tables and create more derived attributes
  data <- loan_data %>%
    rename(loan_date = date) %>%
    left_join(account_data, by = "account_id") %>%
    left_join(trans_data, by = "account_id") %>%
    mutate(transactions_net = transactions_net / age_days) %>%
    mutate(sanctions_rate = sanctions / age_days) %>%
    rename(daily_transactions_net = transactions_net) %>%
    left_join(disp_data, by = "account_id") %>%
    filter(type == "OWNER") %>%
    select(-age_days, -type, -sanctions) %>%
    left_join(card_data, "disp_id") %>%
    mutate(has_card = ifelse(!is.na(card_id), 1, 0)) %>%
    mutate(is_gold = ifelse((!is.na(type) & type == "gold"), 1, 0)) %>%
    select(-card_id, -type, -issued) %>%
    left_join(client_data, by = "client_id") %>%
    mutate(client_age = trunc(as.numeric(
      difftime(as.Date(last_transaction), birthday, units = "weeks")
    ) / 52.25)) %>%
    left_join(district_data, by = "district_id") %>%
    select(-c(name)) %>%
    mutate(can_afford_loan = ifelse(average_salary > payments, 1, 0)) %>%
    mutate(can_pay_until = current_balance / payments) %>%
    mutate(acc_age_when_loan = trunc(as.numeric(
      difftime(loan_date, acc_creation_date, units = "days")))
    ) %>%
    select(-c(acc_creation_date, account_id, district_id, date,
      disp_id, client_id
    )) %>%

    distinct()

  return(data)
}

prepare_datasets(TRUE)
prepare_datasets(FALSE)
