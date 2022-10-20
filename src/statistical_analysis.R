if (!require("purrr")) install.packages("purrr")

account_data <- read.csv("data/account.csv", sep = ";")
card_data <- read.csv("data/card_dev.csv", sep = ";")
client_data <- read.csv("data/client.csv", sep = ";")
disp_data <- read.csv("data/disp.csv", sep = ";")
district_data <- read.csv("data/district.csv", sep = ";")
loan_data <- read.csv("data/loan_dev.csv", sep = ";")
trans_data <- read.csv("data/trans_dev.csv", sep = ";")

client_data <- transform(client_data, gender = ifelse(((birth_number %/% 100) %% 100) < 12, "Male", "Female"))
write.csv(client_data, "data/client-transformed.csv")

# Accounts per region
account_district <- merge(account_data, district_data,
  by.x = "district_id", by.y = "code"
)

loans_per_district <- merge(account_district, loan_data,
  by.x = "account_id", by.y = "account_id"
)

total_loans_per_district <- aggregate(
  loans_per_district$amount,
  list(loans_per_district$name),
  FUN = sum
)

total_loans_per_district <- total_loans_per_district[
  order(total_loans_per_district$x, decreasing = TRUE),
]

png("images/loans-per-district.png")
barplot(total_loans_per_district$x,
  names.arg = total_loans_per_district$Group.1,
  las = 2, cex.names = 0.6
)
dev.off()

png("images/accounts-per-district.png")
barplot(sort(table(account_district$region),
  decreasing = TRUE
), las = 2, cex.names = 0.6, ylim = c(0, 1000))
dev.off()

loan_data$date <- paste("19", loan_data$date, sep = "")
loan_data$date <- as.Date(loan_data$date, "%Y%m%d")


png("images/loans-per-month.png")
hist(loan_data$date,
  breaks = "months",
  main = "Loans per month", xlab = "",
  format = "%b %y", freq = TRUE, las = 2,
)
dev.off()
