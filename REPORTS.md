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
