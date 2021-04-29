# biblia-to-dayone
A script that creates a file to import into Day One app from Biblia app CSV file.

## Usage

```shell
docker run -it -v $PWD:/app -w /app ruby:3.0.1 bash
bundle install
bundle exec ruby biblia-to-dayone.rb --biblia /path/to/biblia/csv
```
