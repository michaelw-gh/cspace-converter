cspace-converter
===

Migrate denormalized or semi-structured data to CollectionSpace from CSV.

Getting Started
---

Ruby (2.x) & Rails are required. The database backend is MongoDB (3.2) and by default should be running on `localhost:27017`.

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

**Initial data import**

The general command is:

```
. ./set_env.sh [CSPACE_CONVERTER_TYPE] [CSPACE_CONVERTER_PROFILE] [CSPACE_CONVERTER_DOMAIN]
./setup.sh
```

Where `converter_type` refers to an available converter module and profile. Concrete examples:

```
. ./set_env.sh PBM cataloging pdm.collectionspace.org
./setup.sh

. ./set_env.sh PastPerfect ppsobjectsdata pp.collectionspace.org
./setup.sh
```

For these commands to actually work you will need the data files in `db/data`.

**Using the console**

```
rails c
p = DataObject.first
puts p.to_cspace_xml("CollectionObject")
```

License
---

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---