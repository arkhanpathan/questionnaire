# Tendable Coding Assessment

  

## Usage

  

```sh

bundle

ruby  questionnaire.rb

```

  

## Goal

  

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

  

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

  

## How It Works

* Questionnaire: The program prompts the user with a series of Yes/No questions.

* Acceptable answers are case-insensitive: Yes, No, Y, N.

* Invalid inputs are handled with an error message, prompting the user to try again.

Answer Persistence:

* The answers and ratings from each run are saved using Ruby's PStore.

PStore is a persistent storage mechanism that stores Ruby objects in a file, allowing us to keep track of answers across multiple runs.

  

## Rating Calculation:

* After each run, the program calculates the percentage of "Yes" answers for that run using the formula:

Rating = (100 * number of Yes answers) / total number of questions

It also computes the average rating over all runs. This is done by summing up all the "Yes" answers and dividing by the total number of questions across all runs.

Output:

After every run, the program prints the rating for that particular run.

It then prints the overall average rating across all runs stored in the PStore.

  

# How to run

use `ruby questionnaire.rb` command

  

# How to run specs

run `rspec`
