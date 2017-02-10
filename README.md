cspace-converter
===

Migrate data to CollectionSpace from CSV.

Getting Started
---

Ruby (2.1.x) & Rails are required. The database backend is MongoDB (3.2) and by default should be running on `localhost:27017`.

```
bundle install
```

Setup
---

Create the data directory and add the data files.

```
db/data/
├── cataloging.csv # custom CSV data file
└── ppsobjectsdata.csv # Past Perfect objects data file
```

**Run MongoDB**

```
# for local development / conversions
docker run --net=host --name mongo -d mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.

**Set the environment**

There is a default `.env` file that provides example configuration. Override it by creating a `.env.local` file with custom settings. To use `lyrasis/collectionspace:latest`:

```
# DEVELOPMENT .env
export CSPACE_CONVERTER_BASE_URI=http://localhost:8180/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
export DISABLE_SPRING=1
```

**Run CollectionSpace**

This will use `lyrasis/collectionspace:latest`:

```
# postgres
docker run --name postgres -d \
  --net=host \
  -e POSTGRES_PASSWORD=654321 \
  -e DB_CSADMIN_PASSWORD=123456 \
  lyrasis/collectionspace:db

# PT.1: create temporary `create_db` container to setup database
docker run --name cspace -it --rm \
  --net=host \
  lyrasis/collectionspace /create_db.sh

# PT.2: run again for collectionspace (omitting `/create_db.sh` and run in background)
docker run --name cspace -d \
  --net=host \
  lyrasis/collectionspace
```

**Initial data import**

The general command is:

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

For these commands to actually work you will need the data files in `db/data`.

**Using the console**

```
./bin/rails c
p = DataObject.first
puts p.to_procedure_xml("CollectionObject")
```

**Running the development server**

```
./bin/rails s
```

To fire jobs created using the ui:

```
./bin/rake jobs:work
```

License
---

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
