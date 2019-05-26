# Webserver Log

## Usage

### Setup

```
bin/setup
```

### Run

```
bundle exec bin/parser webserver.log [OPTIONS]
```

#### Options

`-h`, `--help`:
Show help

`-o`, `--only` [`visits`|`unique_views`]:
- `visits`: List pages by most views
- `unique_views`: List pages by most unique views

`-f`, `--format`:
With the `-o` option, you can choose the output format of the ouput
default: `"%{page} %{value}"`

## Test

Run `bundle exec rspec` to run tests
