# How to generate reports

## Install tools

To generate reports you will need [xcov](https://github.com/nakiostudio/xcov) and [xcpretty](https://github.com/supermarin/xcpretty).
```
gem install xcov
gem install xcpretty
```

## Generate Unit tests coverage report

To get this report run
```
./run_unit_tests_coverage.sh
```

The report is available at
```
./unit_tests_coverage/index.html
```

## Generate Integration tests coverage report

To get this report run
```
./run_integration_tests_coverage.sh
```

The report is available at
```sh
# files coverage
./integration_tests_coverage/index.html

# test methods listing
./integration_tests_coverage/report.html
```

## View reports

You can view reports [here](http://htmlpreview.github.io/?https://github.com/indigo-dc/omt-ios/blob/master/unit_tests_coverage/index.html) and [here](http://htmlpreview.github.io/?https://github.com/indigo-dc/omt-ios/blob/master/integration_tests_coverage/report.html).
