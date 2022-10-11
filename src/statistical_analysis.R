account_data <- read.csv("data/account.csv", sep = ";")
card_data <- read.csv("data/card_dev.csv", sep = ";")
client_data <- read.csv("data/client.csv", sep = ";")
disp_data <- read.csv("data/disp.csv", sep = ";")
district_data <- read.csv("data/district.csv", sep = ";")
loan_data <- read.csv("data/loan_dev.csv", sep = ";")
trans_data <- read.csv("data/trans_dev.csv", sep = ";")


# Accounts per region
account_district <- merge(account_data, district_data,
  by.x = "district_id", by.y = "code"
)

loans_per_district <- merge(account_district, loan_data,
  by.x = "account_id", by.y = "account_id"
)

total_loans_per_district <- aggregate(
  loans_per_districtit$amount,
  list(loans_per_districtit$name),
  FUN = sum
)

total_loans_per_district <- total_loans_per_district[
  order(total_loans_per_district$x, decreasing = TRUE),
]

barplot(total_loans_per_district$x,
  names.arg = total_loans_per_district$Group.1,
  las = 2, cex.names = 0.6
)

barplot(sort(table(account_district$region),
  decreasing = TRUE
), las = 2, cex.names = 0.6, ylim = c(0, 1000))
