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

barplot(sort(table(account_district$region),
    decreasing = TRUE
), las = 2, cex.names = 0.6, ylim = c(0, 1000))

