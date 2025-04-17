# Simple model: resistance based on pathogen & antibiotic
model <- glm(resistant ~ pathogen + antibiotic, data = amr, family = "binomial")
summary(model)

amr$predicted <- predict(model, type = "response")
