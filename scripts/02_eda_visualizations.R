library(ggplot2)

# Resistance by pathogen
amr %>%
  group_by(pathogen) %>%
  summarise(rate = mean(resistant)) %>%
  ggplot(aes(x = reorder(pathogen, rate), y = rate)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Resistance Rate by Pathogen", y = "Resistance Rate", x = "Pathogen")

# Save plot
ggsave("outputs/resistance_by_pathogen.png")
