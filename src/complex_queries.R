account_data <- read.csv("data/account.csv", sep = ";")
card_data <- read.csv("data/card_dev.csv", sep = ";")
client_data <- read.csv("data/client.csv", sep = ";")
disp_data <- read.csv("data/disp.csv", sep = ";")
district_data <- read.csv("data/district.csv", sep = ";")
loan_data <- read.csv("data/loan_dev.csv", sep = ";")
trans_data <- read.csv("data/trans_dev.csv", sep = ";")

final_data <- read.csv("data/dataframe2.csv", sep = ";")

final_data[final_data$frequency == "weekly issuance"]$frequency <- "1"
final_data[final_data$frequency == "monthly issuance"]$frequency <- "2"
final_data[final_data$frequency == "issuance after transaction"]$frequency <- "3"

write.csv(final_data, "data/new.csv", row.names = FALSE)