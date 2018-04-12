# cspace-converter

Migrate data to CollectionSpace from CSV.

## Getting Started

Ruby (2.1.x) & Rails are required. The database backend is MongoDB (3.2) and by
default should be running on `localhost:27017`.

```
bundle install
```

## Setup Data to be Imported

Before the cspace-converter tool can import data into CollectionSpace, it must first
"stage" the data from the CSV files into the Mongo DB.

**Setup CSV file(s)**

Create the data directory and add the data files. For example:

```
db/data/
├── cataloging.csv # custom CSV data file
└── ppsobjectsdata.csv # Past Perfect objects data file
```

**Start MongoDB**

```
# If you don't want to install and run Mongo DB directly, you can
# use a Docker image to run MongoDB -see https://hub.docker.com/r/_/mongo/
docker run --name mongo -d -p 27017:27017 mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.  To test the
connection: https://docs.mongodb.com/v3.0/tutorial/getting-started-with-the-mongo-shell/

**Stage the data to MongoDB**

The general format for the command is:

```
./import.sh [CS_CONV_BATCH] [CS_CONV_TYPE] [CS_CONV_PROFILE] [CS_CONV_FILE]
```

- `CS_CONV_BATCH`: batch name
- `CS_CONV_TYPE`: converter type (module)
- `CS_CONV_PROFILE`: profile from type
- `CS_CONV_FILE`: filename (without extension)

For example:

```
./import.sh pp_accession1 PastPerfect accessions PPSdata_accession
./import.sh pp_objects1 PastPerfect objects PPSdata_objects
```

For these commands to actually work you will need the data (CSV) files in `db/data`. Here's the command using supplied sample CSV data:

```
./import.sh cataloging Vanilla cataloging SampleCatalogingData
```

## Import Staged Data (data in MongoDB) to CollectionSpace

**Set the environment**

There is a default `.env` file that provides example configuration. Override it
by creating a `.env.local` file with custom settings.

To use `lyrasis/collectionspace:latest`:

```
# DEVELOPMENT .env
export CSPACE_CONVERTER_BASE_URI=http://localhost:8180/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
export DISABLE_SPRING=1
```

**Start CollectionSpace**

If you don't want to install and run CollectionSpace directly, you can
use a Docker image to run CollectionSpace

For local testing only: [docker-collectionspace](https://github.com/lyrasis/docker-collectionspace).

**Starting/Running the development server**

```
./bin/rails s
```
Once started, visit http://localhost:3000 with a web browser.

To fire jobs created using the ui:

```
./bin/rake jobs:work
```

**Using the console**

```
./bin/rails c
p = DataObject.first
puts p.to_procedure_xml("CollectionObject")
```

## (Optional) Test environment

```
docker-compose build
docker-compose up

# to run commands
docker exec -it converter ./bin/rails c
docker exec -it converter \
  ./import.sh cataloging Vanilla cataloging SampleCatalogingData
docker exec -it converter ./bin/rake db:nuke
```

## Deploying Converter to Amazon Elastic Beanstalk

The converter can be easily deployed to [Amazon Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/)
(account required).

```
cp Dockerrun.aws-example.json Dockerrun.aws.json
```

Replace the `INSERT_YOUR_VALUE_HERE` values as needed. Note: for a production
environment the `username` and `password` should be for a temporary account used
only to perform the migration tasks. Delete this user from CollectionSpace when
the migration has been completed.

Follow the AWS documentation for deployment details:

- [Getting started](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/GettingStarted.html)

Summary:

- Create a new application and give it a name
- Choose Web application
- Choose Multi-container docker, single instance
- Upload your custom Dockerrun-aws.json (under application version)
- Choose a domain name (can be customized further later)
- Skip RDS and VPC (the mongo db is isolated to a docker local network)
- Select `t2.small` for instance type (everything else optional)
- Launch

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
