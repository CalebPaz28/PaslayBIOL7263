

library(learnr)

ex_question <- question("What number is the letter A in the alphabet?",
                        answer("8"),
                        answer("14"),
                        answer("1", correct = TRUE),
                        answer("23"),
                        incorrect = "See [here](https://en.wikipedia.org/wiki/English_alphabet) and try again.",
                        allow_retry = TRUE
)
