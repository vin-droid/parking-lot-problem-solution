# Parking Lot Problem Solution

**Problem Statement:**
A Parking lot can hold up to 'n' cars at any given point in time. Each slot is
given a number starting at 1 increasing with increasing distance from the entry point
in steps of one.

When a car enters the parking lot, a ticket issued to the driver. 
The ticket issuing process includes documenting fallowing:
* *the registration number (number plate).*
* *the colour of the car.*
* *allocating an available parking slot to the car.*

**Note:** The customer should be allocated a parking slot which is nearest to the entry.

At the exit, the customer returns the ticket which then marks the slot they were using as being available.

Due to government regulation, the system should provide:
* *Registration numbers of all cars of a particular colour.*
* *Slot number in which a car with a given registration number is parked.*
* *Slot numbers of all slots where a car of a particular colour is parked.*

## Setup
First, install [Ruby](https://www.ruby-lang.org/en/documentation/installation/). Then run the following commands under the `functional_spec` dir.

```
functional_spec $ ruby -v # confirm Ruby present
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]
functional_spec $ gem install bundler # install bundler to manage dependencies
Successfully installed bundler-1.16.1
Parsing documentation for bundler-1.16.1
Done installing documentation for bundler after 2 seconds
1 gem installed
functional_spec $ bundle install # install dependencies
...
...
Bundle complete! 3 Gemfile dependencies, 8 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
functional_spec $ 

```

## Usage

You can run the following commands under the `parking_lot` dir to make executable file.
```
parking_lot $ chmod +x bin/parking_lot
```

Then run the full suite from `parking_lot` by doing
```
parking_lot $ bin/parking_lot file_input.txt
```

You can execute run the program and launch the shell
```
parking_lot $ bin/parking_lot
```