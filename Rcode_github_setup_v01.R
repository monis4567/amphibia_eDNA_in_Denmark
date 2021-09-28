


# in a terminal
# git config --global user.email "steen.knudsen@niva-dk.dk"
# git config --global user.name "MONIS4567"
# https://stackoverflow.com/questions/66065099/how-to-update-github-authentification-token-on-rstudio-to-match-the-new-policy

install.packages("gitcreds")
library(gitcreds)
gitcreds_set()

# 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

install.packages("credentials")
library(credentials)
git_credential_update(url = "https://github.com", verbose = TRUE)

install.packages("usethis")
library(usethis)
#