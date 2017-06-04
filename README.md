![Tam Boon](https://cdn.omise.co/assets/tamboon.jpg)

# Tam Boon

_Tam boon_ (which means "making merit" in Thai) is a simple Ruby on Rails
app that contains bugs and rough code that you need to fix and refactor
in order to be offered an interview at Omise.

Read this document entirely before starting the exercises as you'll learn how
we expect you to write code, our rules for code and how to submit your changes
back to us.

## Setup

This app provides a way for merit makers to donate money to a charity of their
choosing using their credit card.

At the root path you will find a list of charities, a field to enter an amount,
and a series of credit card fields powered by Omise. The amount must be sent in
Thai Baht. But both the Omise API and the `total` column in the charity
table expect an integer value in the smallest unit of the Thai Baht, the
satang.

Note that you must register an Omise account and replace both the `pkey`
and `skey` fields in `config/secrets.yml` to use the app in development
mode.

To run the test simply run `rake test`. You'll notice that two tests already
fail. You'll have to fix or add code (without changing the test) to make
the tests pass.



